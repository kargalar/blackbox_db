import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/8_Model/genre_model.dart';
import 'package:blackbox_db/8_Model/language_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreProvider with ChangeNotifier {
  ExploreProvider._privateConstructor();
  static final ExploreProvider _instance = ExploreProvider._privateConstructor();
  factory ExploreProvider() {
    return _instance;
  }

  int currentPageIndex = 1;
  late int totalPageIndex;

  List<GenreModel> genreFilteredList = [];
  LanguageModel? languageFilter;

  List<GenreModel>? allMovieGenres;
  List<GenreModel>? allGameGenres;
  List<LanguageModel>? allMovieLanguage;
  // List<LanguageModel>? allGameLanguage;

  // rating filter

  List<ShowcaseContentModel> contentList = [];

  bool isLoadingPage = true;
  bool isLoadingContents = true;

  String? profileUserID;

  void getContent({required BuildContext context}) async {
    try {
      if (!isLoadingPage) {
        isLoadingContents = true;
        notifyListeners();
      }

      late dynamic response;

      if (profileUserID != null) {
        // Profile sayfası - MigrationService kullan (user-specific data)
        response = await MigrationService().getUserContents(
          contentType: context.read<ProfileProvider>().contentType,
          logUserId: profileUserID!,
        );
      } else {
        // Explore sayfası - ExternalApiService kullan (discover functionality)
        String? currentUserId;
        try {
          final currentUser = await MigrationService().getCurrentUserProfile();
          currentUserId = currentUser?.id;
        } catch (e) {
          debugPrint('Current user ID alınamadı: $e');
        }

        // ignore: use_build_context_synchronously
        if (context.read<GeneralProvider>().exploreContentType == ContentTypeEnum.MOVIE) {
          // Film keşfet - ExternalApiService ile
          final result = await ExternalApiService().discoverMovies(
            page: currentPageIndex,
            userId: currentUserId,
          );

          // Response formatını showcase_content_model'e uyarla
          response = {
            'contentList': _convertToShowcaseContentModel(result['contents'] ?? [], true),
            'totalPages': result['total_pages'] ?? 0,
          };
          // ignore: use_build_context_synchronously
        } else if (context.read<GeneralProvider>().exploreContentType == ContentTypeEnum.GAME) {
          // Oyun keşfet - ExternalApiService ile
          final result = await ExternalApiService().discoverGames(
            offset: (currentPageIndex - 1) * 20,
            userId: currentUserId,
          );

          // Response formatını showcase_content_model'e uyarla
          response = {
            'contentList': _convertToShowcaseContentModel(result['contents'] ?? [], false),
            'totalPages': result['total_pages'] ?? 0,
          };
        }
      }

      contentList = response['contentList'];
      totalPageIndex = response['totalPages'];

      isLoadingPage = false;
      isLoadingContents = false;

      notifyListeners();
    } catch (e) {
      debugPrint('Explore content error: $e');
      isLoadingPage = false;
      isLoadingContents = false;
      notifyListeners();
    }
  }

  /// External API response'unu ShowcaseContentModel'e çevirir
  List<ShowcaseContentModel> _convertToShowcaseContentModel(
    List<dynamic> apiContents,
    bool isMovie,
  ) {
    return apiContents.map((content) {
      String? posterPath;

      if (isMovie) {
        // TMDB movie format
        posterPath = content['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${content['poster_path']}' : null;
      } else {
        // IGDB game format
        final coverId = content['cover']?['image_id'];
        posterPath = coverId != null ? 'https://images.igdb.com/igdb/image/upload/t_cover_big/$coverId.jpg' : null;
      }

      return ShowcaseContentModel(
        contentId: content['id'],
        posterPath: posterPath,
        contentType: isMovie ? ContentTypeEnum.MOVIE : ContentTypeEnum.GAME,
        isFavorite: content['user_is_favorite'] ?? false,
        contentStatus: content['user_content_status_id'] != null ? ContentStatusEnum.values[content['user_content_status_id'] - 1] : null,
        isConsumeLater: content['user_is_consume_later'] ?? false,
        rating: content['user_rating']?.toDouble(),
      );
    }).toList();
  }
}
