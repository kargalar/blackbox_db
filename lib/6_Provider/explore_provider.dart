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
  double? minRatingFilter; // 0-10 arası Supabase ortalama puan
  String? yearFromFilter; // YYYY
  String? yearToFilter; // YYYY

  List<GenreModel>? allMovieGenres;
  List<GenreModel>? allGameGenres;
  List<LanguageModel>? allMovieLanguage;
  // List<LanguageModel>? allGameLanguage;

  // rating filter

  List<ShowcaseContentModel> contentList = [];

  bool isLoadingPage = true;
  bool isLoadingContents = true;

  String? profileUserID;

  Future<void> _ensureStaticDataLoaded(ContentTypeEnum type) async {
    try {
      if (type == ContentTypeEnum.MOVIE) {
        if (allMovieGenres == null) {
          final raw = await ExternalApiService().getMovieGenres();
          allMovieGenres = GenreModel.fromJsonList(raw);
        }
        if (allMovieLanguage == null) {
          final rawLang = await ExternalApiService().getMovieLanguages();
          allMovieLanguage = LanguageModel.fromJsonList(rawLang);
        }
      } else if (type == ContentTypeEnum.GAME) {
        if (allGameGenres == null) {
          final raw = await ExternalApiService().getGameGenres();
          allGameGenres = GenreModel.fromJsonList(raw);
        }
      }
    } catch (e) {
      debugPrint('Static data load error: $e');
    }
  }

  void getContent({required BuildContext context}) async {
    try {
      if (!isLoadingPage) {
        isLoadingContents = true;
        notifyListeners();
      }

      late dynamic response;

      final exploreType = context.read<GeneralProvider>().exploreContentType;
      await _ensureStaticDataLoaded(exploreType);

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
        if (exploreType == ContentTypeEnum.MOVIE) {
          // Film keşfet - ExternalApiService ile
          final result = await ExternalApiService().discoverMovies(
            page: currentPageIndex,
            userId: currentUserId,
            withGenres: genreFilteredList.isNotEmpty ? genreFilteredList.map((e) => e.id).join(',') : null,
            withOriginalLanguage: languageFilter?.iso,
            yearFrom: yearFromFilter,
            yearTo: yearToFilter,
          );

          // Response formatını showcase_content_model'e uyarla
          response = {
            'contentList': _convertToShowcaseContentModel(result['contents'] ?? [], true),
            'totalPages': result['total_pages'] ?? 0,
          };
          // ignore: use_build_context_synchronously
        } else if (exploreType == ContentTypeEnum.GAME) {
          // Oyun keşfet - ExternalApiService ile
          final result = await ExternalApiService().discoverGames(
            offset: (currentPageIndex - 1) * 20,
            userId: currentUserId,
            // IGDB Discover için henüz yıl / rating filtreleri eklenmedi (gerekirse genişletilebilir)
          );

          // Response formatını showcase_content_model'e uyarla
          response = {
            'contentList': _convertToShowcaseContentModel(result['contents'] ?? [], false),
            'totalPages': result['total_pages'] ?? 0,
          };
        }
      }

      contentList = response['contentList'];

      // Supabase tabanlı ortalama rating filtresi uygulama (user_rating değil; global ortalama gerektiriyor ise migration service'den alınmalı)
      if (minRatingFilter != null) {
        // İçerik id'leri için Supabase'ten ortalama ratingleri çek
        final idList = contentList.map((e) => e.contentId).toList();
        final avgMap = await MigrationService().getAverageRatingsForContentIds(idList);
        contentList = contentList.where((c) {
          final avg = avgMap[c.contentId];
          if (avg == null) return false; // rating yoksa hariç
          return avg >= minRatingFilter!;
        }).toList();
      }

      // Genre dışı kategori filtresi kaldırıldı (kullanıcı isteği: genre zaten yeterli)
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
        posterPath = content['poster_path'];
      } else {
        final coverId = content['cover']?['image_id'];
        posterPath = coverId; // raw id, ContentPoster will compose URL
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
