import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/explore_sort_enum.dart';
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
  ExploreSortEnum sort = ExploreSortEnum.defaultOrder;

  List<GenreModel>? allMovieGenres;
  List<GenreModel>? allGameGenres;
  List<LanguageModel>? allMovieLanguage;
  // List<LanguageModel>? allGameLanguage;

  // rating filter

  List<ShowcaseContentModel> contentList = [];
  // Global aggregation cache for user rating sort
  List<ShowcaseContentModel>? _aggregatedUserRatingList;
  static const int _moviePageSize = 20; // TMDB default
  static const int _aggregateMaxPages = 10; // configurable cap (200 items)

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

      // Eğer ratingAsc / ratingDesc değilse aggregation cache temizle
      if (!(sort == ExploreSortEnum.ratingDesc || sort == ExploreSortEnum.ratingAsc)) {
        _aggregatedUserRatingList = null;
      }

      // GLOBAL USER RATING SIRALAMA (Movies) - çoklu sayfa topla & Supabase avg uygula
      final isGlobalUserRatingSort = (sort == ExploreSortEnum.ratingDesc || sort == ExploreSortEnum.ratingAsc) && profileUserID == null && exploreType == ContentTypeEnum.MOVIE;
      if (isGlobalUserRatingSort) {
        // Yeniden oluşturma gerekiyorsa (ilk sayfa veya cache yok)
        if (_aggregatedUserRatingList == null || currentPageIndex == 1) {
          List<ShowcaseContentModel> aggregate = [];
          String? currentUserId;
          try {
            final currentUser = await MigrationService().getCurrentUserProfile();
            currentUserId = currentUser?.id;
          } catch (e) {
            debugPrint('Current user ID alınamadı: $e');
          }

          int remoteTotalPages = 1;
          for (int p = 1; p <= _aggregateMaxPages; p++) {
            final result = await ExternalApiService().discoverMovies(
              page: p,
              userId: currentUserId,
              withGenres: genreFilteredList.isNotEmpty ? genreFilteredList.map((e) => e.id).join(',') : null,
              withOriginalLanguage: languageFilter?.iso,
              yearFrom: yearFromFilter,
              yearTo: yearToFilter,
            );
            remoteTotalPages = result['total_pages'] ?? remoteTotalPages;
            final pageList = _convertToShowcaseContentModel(result['contents'] ?? [], true);
            if (pageList.isEmpty) break;
            aggregate.addAll(pageList);
            if (p >= remoteTotalPages) break; // tüm sayfalar bitti
          }

          // Supabase ortalama ratingleri çek & model rating alanına ata
          final idList = aggregate.map((e) => e.contentId).toList();
          final avgMap = await MigrationService().getAverageRatingsForContentIds(idList);
          for (final item in aggregate) {
            final avg = avgMap[item.contentId];
            if (avg != null) item.rating = avg; // user average rating
          }

          // minRatingFilter uygula (avg bazlı)
          if (minRatingFilter != null) {
            aggregate = aggregate.where((c) => (c.rating ?? 0) >= minRatingFilter!).toList();
          }

          // Sırala
          aggregate.sort((a, b) => sort == ExploreSortEnum.ratingDesc ? (b.rating ?? 0).compareTo(a.rating ?? 0) : (a.rating ?? 0).compareTo(b.rating ?? 0));

          _aggregatedUserRatingList = aggregate;
          // Toplam sayfa hesapla
          final totalItems = aggregate.length;
          totalPageIndex = (totalItems / _moviePageSize).ceil().clamp(1, 9999);
        }

        // Slice current page
        final start = (currentPageIndex - 1) * _moviePageSize;
        final end = (start + _moviePageSize).clamp(0, _aggregatedUserRatingList!.length);
        contentList = start < _aggregatedUserRatingList!.length ? _aggregatedUserRatingList!.sublist(start, end) : [];

        isLoadingPage = false;
        isLoadingContents = false;
        notifyListeners();
        return; // normal akışa girme
      }

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
          String? remoteSort;
          switch (sort) {
            case ExploreSortEnum.globalRatingDesc:
              remoteSort = 'vote_average.desc';
              break;
            case ExploreSortEnum.globalRatingAsc:
              remoteSort = 'vote_average.asc';
              break;
            case ExploreSortEnum.popularityDesc:
              remoteSort = 'popularity.desc';
              break;
            case ExploreSortEnum.yearDesc:
              remoteSort = 'primary_release_date.desc';
              break;
            case ExploreSortEnum.yearAsc:
              remoteSort = 'primary_release_date.asc';
              break;
            default:
              remoteSort = null; // local veya default
          }
          final result = await ExternalApiService().discoverMovies(
            page: currentPageIndex,
            userId: currentUserId,
            withGenres: genreFilteredList.isNotEmpty ? genreFilteredList.map((e) => e.id).join(',') : null,
            withOriginalLanguage: languageFilter?.iso,
            yearFrom: yearFromFilter,
            yearTo: yearToFilter,
            sortBy: remoteSort,
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

      // Sıralama uygula
      switch (sort) {
        case ExploreSortEnum.defaultOrder:
          break; // API'nin verdiği sırayı koru
        case ExploreSortEnum.ratingDesc:
          contentList.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0)); // (page local)
          break;
        case ExploreSortEnum.ratingAsc:
          contentList.sort((a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0));
          break;
        case ExploreSortEnum.yearDesc:
          // remoteSort ile zaten sıralandıysa tekrar gerek yok
          if (currentPageIndex == 1) {} // no-op placeholder
          break;
        case ExploreSortEnum.yearAsc:
          if (currentPageIndex == 1) {}
          break;
        case ExploreSortEnum.globalRatingDesc:
          // remote sort kullanıldı
          break;
        case ExploreSortEnum.globalRatingAsc:
          // remote sort kullanıldı
          break;
        case ExploreSortEnum.popularityDesc:
          // remote sort kullanıldı
          break;
        case ExploreSortEnum.watchlistFirst:
          contentList.sort((a, b) {
            if (a.isConsumeLater == b.isConsumeLater) {
              return (b.globalRating ?? 0).compareTo(a.globalRating ?? 0);
            }
            return a.isConsumeLater ? -1 : 1;
          });
          break;
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
        year: _extractYear(content, isMovie),
        popularity: isMovie ? _toDouble(content['popularity']) : null,
        globalRating: _toDouble(isMovie ? content['vote_average'] : content['rating']),
      );
    }).toList();
  }

  int? _extractYear(Map<String, dynamic> content, bool isMovie) {
    try {
      if (isMovie) {
        final date = content['release_date'] ?? content['first_air_date'];
        if (date is String && date.length >= 4) return int.tryParse(date.substring(0, 4));
      } else {
        final ts = content['first_release_date'];
        if (ts is int) {
          // IGDB first_release_date genelde epoch seconds
          final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000, isUtc: true);
          return dt.year;
        }
      }
    } catch (_) {}
    return null;
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
