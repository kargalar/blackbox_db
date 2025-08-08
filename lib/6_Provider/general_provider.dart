import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/search_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralProvider with ChangeNotifier {
  GeneralProvider._privateConstructor();
  static final GeneralProvider _instance = GeneralProvider._privateConstructor();
  factory GeneralProvider() {
    return _instance;
  }

  int currentIndex = 0;
  ContentTypeEnum searchFilter = ContentTypeEnum.MOVIE;
  ContentTypeEnum exploreContentType = ContentTypeEnum.MOVIE;
  int contentID = 0;
  ContentTypeEnum contentPageContentTpye = ContentTypeEnum.MOVIE;

  // serach
  bool searchIsLoading = true;
  late List<SearchContentModel> searchContentList;

  void home() {
    currentIndex = 0;
    notifyListeners();
  }

  Future search(String searchText) async {
    if (!searchIsLoading) {
      searchIsLoading = true;
      notifyListeners();
    }

    currentIndex = 1;
    notifyListeners();

    try {
      // Current user ID'sini al
      String? currentUserId;
      try {
        final currentUser = await MigrationService().getCurrentUserProfile();
        currentUserId = currentUser?.id;
      } catch (e) {
        debugPrint('Current user ID alınamadı: $e');
      }

      // ExternalApiService ile arama yap
      if (searchFilter == ContentTypeEnum.MOVIE) {
        final result = await ExternalApiService().searchContent(
          query: searchText,
          contentTypeId: 1, // Movie
          page: 1,
          userId: currentUserId,
        );

        // Search result'ını SearchContentModel'e çevir
        searchContentList = _convertToSearchContentModel(
          result['contents'] ?? [],
          true, // isMovie
        );
      } else if (searchFilter == ContentTypeEnum.GAME) {
        final result = await ExternalApiService().searchContent(
          query: searchText,
          contentTypeId: 2, // Game
          page: 1,
          userId: currentUserId,
        );

        // Search result'ını SearchContentModel'e çevir
        searchContentList = _convertToSearchContentModel(
          result['contents'] ?? [],
          false, // isMovie
        );
      } else {
        searchContentList = [];
      }

      searchIsLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Search error: $e');
      searchIsLoading = false;
      notifyListeners();
    }
  }

  /// External API search response'unu SearchContentModel'e çevirir
  List<SearchContentModel> _convertToSearchContentModel(
    List<dynamic> apiContents,
    bool isMovie,
  ) {
    return apiContents.map((content) {
      String? posterPath;

      if (isMovie) {
        posterPath = content['poster_path'];
      } else {
        final coverId = content['cover']?['image_id'];
        posterPath = coverId; // raw id, ContentPoster builds full URL
      }

      return SearchContentModel(
        contentId: content['id'],
        contentPosterPath: posterPath,
        contentType: isMovie ? ContentTypeEnum.MOVIE : ContentTypeEnum.GAME,
        isFavorite: content['user_is_favorite'] ?? false,
        isConsumed: content['user_content_status_id'] != null,
        isConsumeLater: content['user_is_consume_later'] ?? false,
        rating: content['user_rating']?.toDouble(),
        isReviewed: content['user_review_id'] != null,
        title: content['title'] ?? content['name'] ?? 'No Title',
        description: content['overview'] ?? content['summary'],
        year: _extractYear(content, isMovie),
        originalTitle: content['original_title'] ?? content['name'],
      );
    }).toList();
  }

  /// Release date'ten yıl çıkarır
  String? _extractYear(Map<String, dynamic> content, bool isMovie) {
    if (isMovie) {
      final releaseDate = content['release_date'];
      if (releaseDate != null && releaseDate.isNotEmpty) {
        return releaseDate.substring(0, 4);
      }
    } else {
      final releaseDate = content['first_release_date'];
      if (releaseDate != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(releaseDate * 1000);
        return date.year.toString();
      }
    }
    return null;
  }

  void explore(ContentTypeEnum contentType, BuildContext context) {
    // TODO: movie, book veya game e her tıkladığında tekrar yüklesin
    exploreContentType = contentType;
    currentIndex = 2;

    Provider.of<ExploreProvider>(context, listen: false).languageFilter = null;
    Provider.of<ExploreProvider>(context, listen: false).genreFilteredList = [];
    Provider.of<ExploreProvider>(context, listen: false).currentPageIndex = 1;
    Provider.of<ExploreProvider>(context, listen: false).profileUserID = null;
    Provider.of<ExploreProvider>(context, listen: false).getContent(context: context);

    notifyListeners();
  }

  void profile(String userId) async {
    ProfileProvider().getUserInfo(userId);
    currentIndex = 3;
    notifyListeners();
  }

  void content(int contentID, ContentTypeEnum contentType) {
    this.contentID = contentID;
    contentPageContentTpye = contentType;
    currentIndex = 4;
    notifyListeners();
  }

  void managerPanel() {
    currentIndex = 5;
    notifyListeners();
  }
}
