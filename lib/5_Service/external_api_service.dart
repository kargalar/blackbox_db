import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';

/// External API Service - TMDB ve IGDB API'lerini yönetir ve Supabase ile entegre eder
/// Eski backend'teki tüm API işlemlerini Flutter'a taşır - Tam backend replacement
class ExternalApiService {
  ExternalApiService._privateConstructor();
  static final ExternalApiService _instance = ExternalApiService._privateConstructor();
  factory ExternalApiService() => _instance;

  // TMDB Configuration
  static const String _tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static final String _tmdbToken = dotenv.env['TMDB_Token']!;

  // IGDB Configuration
  static const String _igdbBaseUrl = 'https://api.igdb.com/v4';
  static final String _igdbClientId = dotenv.env['IGDB_Client_id']!;
  static final String _igdbToken = dotenv.env['IGDB_Authorization']!;

  final MigrationService _migrationService = MigrationService();

  // TMDB Headers
  Map<String, String> get _tmdbHeaders => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_tmdbToken',
      };

  // IGDB Headers
  Map<String, String> get _igdbHeaders => {
        'Accept': 'application/json',
        'Client-ID': _igdbClientId,
        'Authorization': _igdbToken, // .env dosyasında zaten "Bearer " prefix'i var
      };

  // ********************************************
  // CONTENT DETAIL - Backend /content_detail endpoint
  // ********************************************

  /// Content detayını getir - BACKEND REPLACEMENT
  /// 1. Önce Supabase'de ara
  /// 2. Yoksa external API'den çek
  /// 3. Supabase'e kaydet
  /// 4. User logs ile birleştir
  Future<ContentModel?> getContentDetail({
    required int contentId,
    required int contentTypeId,
    String? userId,
  }) async {
    try {
      // ADIM 1: Önce Supabase'de var mı kontrol et
      try {
        final existingContent = await _migrationService.getContentDetail(
          contentId: contentId,
          contentType: contentTypeId == 1 ? ContentTypeEnum.MOVIE : ContentTypeEnum.GAME,
          userId: userId,
        );

        debugPrint('✅ Content found in Supabase: $contentId');
        return existingContent;
      } catch (e) {
        debugPrint('❌ Content not found in Supabase, fetching from external API: $contentId');
      }

      // ADIM 2 & 3: External API'den çek ve kaydet
      if (contentTypeId == 1) {
        return await _fetchAndSaveMovieFromTMDB(contentId, userId);
      } else if (contentTypeId == 2) {
        return await _fetchAndSaveGameFromIGDB(contentId, userId);
      }

      return null;
    } catch (e) {
      debugPrint('Error getting content detail: $e');
      return null;
    }
  }

  // ********************************************
  // MOVIE API METHODS - TMDB Integration
  // ********************************************

  /// TMDB'den film detayını çek, user logs ile birleştir ve Supabase'e kaydet
  Future<ContentModel?> _fetchAndSaveMovieFromTMDB(int movieId, String? userId) async {
    try {
      debugPrint('🎬 Fetching movie from TMDB: $movieId');

      // Film temel bilgilerini al
      final movieResponse = await http.get(
        Uri.parse('$_tmdbBaseUrl/movie/$movieId'),
        headers: _tmdbHeaders,
      );

      if (movieResponse.statusCode != 200) {
        debugPrint('Movie not found on TMDB: $movieId');
        return null;
      }

      final movieData = json.decode(movieResponse.body);

      // ADIM 3: Supabase'e sadece temel alanları kaydet (cast_list, genre_list hariç)
      try {
        final basicMovieData = {
          'id': movieData['id'],
          'title': movieData['title'],
          'description': movieData['overview'],
          'poster_path': movieData['poster_path'],
          'release_date': movieData['release_date'],
          'content_type_id': 1, // Movie
          'length': movieData['runtime'],
          // Complex fields skip edildi: cast_list, creator_list, genre_list
        };

        await _migrationService.client.from('content').insert(basicMovieData);
        debugPrint('✅ Movie saved to Supabase: ${movieData['id']}');
      } catch (e) {
        debugPrint('⚠️ Error saving movie to Supabase: $e');
        // Kaydetme hatası olsa bile content'i döndür
      }

      // ADIM 4: ContentModel oluştur (response için)
      final content = ContentModel(
        id: movieData['id'],
        title: movieData['title'],
        description: movieData['overview'],
        posterPath: movieData['poster_path'],
        releaseDate: movieData['release_date'] != null ? DateTime.parse(movieData['release_date']) : null,
        contentType: ContentTypeEnum.MOVIE,
        length: movieData['runtime'],
        // Complex fields null
        cast: null,
        creatorList: null,
        genreList: null,
        ratingDistribution: null, // Null olarak bırak, UI'da handle edilecek
        // Stats fields default
        consumeCount: 0,
        favoriCount: 0,
        listCount: 0,
        reviewCount: 0,
        // User fields default
        contentStatus: null,
        rating: null,
        isFavorite: false, // Default false
        isConsumeLater: false, // Default false
      );

      // ADIM 4: Eğer userId varsa, user logs ile birleştir
      if (userId != null) {
        try {
          final userContent = await _migrationService.getContentDetail(
            contentId: movieId,
            contentType: ContentTypeEnum.MOVIE,
            userId: userId,
          );
          return userContent;
        } catch (e) {
          debugPrint('⚠️ Error getting user content after save: $e');
        }
      }

      return content;
    } catch (e) {
      debugPrint('Error fetching movie from TMDB: $e');
      return null;
    }
  }

  /// IGDB'den oyun detayını çek, user logs ile birleştir ve Supabase'e kaydet
  Future<ContentModel?> _fetchAndSaveGameFromIGDB(int gameId, String? userId) async {
    try {
      debugPrint('🎮 Fetching game from IGDB: $gameId');

      final response = await http.post(
        Uri.parse('$_igdbBaseUrl/games'),
        headers: _igdbHeaders,
        body: 'fields id,name,summary,cover.image_id,first_release_date,storyline; where id = $gameId;',
      );

      if (response.statusCode != 200) {
        debugPrint('Game not found on IGDB: $gameId');
        return null;
      }

      final data = json.decode(response.body);
      if (data.isEmpty) {
        return null;
      }

      final game = data[0];

      // ADIM 3: Supabase'e sadece temel alanları kaydet
      try {
        final basicGameData = {
          'id': game['id'],
          'title': game['name'],
          'description': game['summary'] ?? game['storyline'],
          'poster_path': game['cover']?['image_id'] != null ? game['cover']['image_id'] : null,
          'release_date': game['first_release_date'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(game['first_release_date'] * 1000)) : null,
          'content_type_id': 2, // Game
          // Complex fields skip edildi: cast_list, creator_list, genre_list
        };

        await _migrationService.client.from('content').insert(basicGameData);
        debugPrint('✅ Game saved to Supabase: ${game['id']}');
      } catch (e) {
        debugPrint('⚠️ Error saving game to Supabase: $e');
      }

      // ADIM 4: ContentModel oluştur (response için)
      final content = ContentModel(
        id: game['id'],
        title: game['name'],
        description: game['summary'] ?? game['storyline'],
        posterPath: game['cover']?['image_id'] != null ? game['cover']['image_id'] : null,
        releaseDate: game['first_release_date'] != null ? DateTime.fromMillisecondsSinceEpoch(game['first_release_date'] * 1000) : null,
        contentType: ContentTypeEnum.GAME,
        // Complex fields null
        cast: null,
        creatorList: null,
        genreList: null,
        ratingDistribution: null, // Null olarak bırak, UI'da handle edilecek
        // Stats fields default
        consumeCount: 0,
        favoriCount: 0,
        listCount: 0,
        reviewCount: 0,
        // User fields default
        contentStatus: null,
        rating: null,
        isFavorite: false, // Default false
        isConsumeLater: false, // Default false
      );

      // Eğer userId varsa, user logs ile birleştir
      if (userId != null) {
        try {
          final userContent = await _migrationService.getContentDetail(
            contentId: gameId,
            contentType: ContentTypeEnum.GAME,
            userId: userId,
          );
          return userContent;
        } catch (e) {
          debugPrint('⚠️ Error getting user content after save: $e');
        }
      }

      return content;
    } catch (e) {
      debugPrint('Error fetching game from IGDB: $e');
      return null;
    }
  }

  // ********************************************
  // DISCOVER METHODS - Backend /discoverMovie ve /discoverGame endpoints
  // ********************************************

  /// Film keşfet - BACKEND /discoverMovie REPLACEMENT
  Future<Map<String, dynamic>> discoverMovies({
    String? withGenres,
    String? withOriginalLanguage,
    String? year,
    int page = 1,
    String? userId,
  }) async {
    try {
      String url = '$_tmdbBaseUrl/discover/movie?include_adult=false&include_video=false&page=$page';

      if (withGenres != null) url += '&with_genres=$withGenres';
      if (year != null) url += '&primary_release_year=$year';
      if (withOriginalLanguage != null) url += '&with_original_language=$withOriginalLanguage';

      final response = await http.get(Uri.parse(url), headers: _tmdbHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movieResults = List<Map<String, dynamic>>.from(data['results'] ?? []);

        // User logs ile birleştir (backend'teki gibi)
        if (userId != null && movieResults.isNotEmpty) {
          final movieIds = movieResults.map((movie) => movie['id'] as int).toList();
          final userLogs = await _getUserLogsForContents(userId, movieIds);

          // Her film için user log ekle
          for (var movie in movieResults) {
            final movieId = movie['id'];
            final userLog = userLogs[movieId];

            movie['user_is_favorite'] = userLog?['is_favorite'] ?? false;
            movie['user_is_consume_later'] = userLog?['is_consume_later'] ?? false;
            movie['user_rating'] = userLog?['rating'];
            movie['user_content_status_id'] = userLog?['content_status_id'];
            movie['user_review_id'] = userLog?['review_id'];
          }
        }

        return {
          'contents': movieResults,
          'total_pages': data['total_pages'],
        };
      }
    } catch (e) {
      debugPrint('Error discovering movies: $e');
    }

    return {'contents': [], 'total_pages': 0};
  }

  /// Oyun keşfet - BACKEND /discoverGame REPLACEMENT
  Future<Map<String, dynamic>> discoverGames({
    String? genre,
    String? year,
    int offset = 0,
    String? userId,
  }) async {
    try {
      String filters = 'where version_parent = null & category = 0 & platforms = (6)';
      if (genre != null) filters += ' & genres = ($genre)';
      if (year != null) {
        filters += ' & first_release_date >= $year-01-01 & first_release_date <= $year-12-31';
      }

      final body = 'fields id,cover.image_id,name,summary,first_release_date; $filters; limit 20; offset $offset; sort rating desc;';

      final response = await http.post(
        Uri.parse('$_igdbBaseUrl/games'),
        headers: _igdbHeaders,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          final gameResults = List<Map<String, dynamic>>.from(data);

          // User logs ile birleştir
          if (userId != null) {
            final gameIds = gameResults.map((game) => game['id'] as int).toList();
            final userLogs = await _getUserLogsForContents(userId, gameIds);

            // Her oyun için user log ekle
            for (var game in gameResults) {
              final gameId = game['id'];
              final userLog = userLogs[gameId];

              game['user_is_favorite'] = userLog?['is_favorite'] ?? false;
              game['user_is_consume_later'] = userLog?['is_consume_later'] ?? false;
              game['user_rating'] = userLog?['rating'];
              game['user_content_status_id'] = userLog?['content_status_id'];
              game['user_review_id'] = userLog?['review_id'];
            }
          }

          return {
            'contents': gameResults,
            'total_pages': 50, // IGDB'de hesaplamak zor
          };
        }
      }
    } catch (e) {
      debugPrint('Error discovering games: $e');
    }

    return {'contents': [], 'total_pages': 0};
  }

  // ********************************************
  // RECOMMENDATION METHODS - Backend /recommendContent endpoint
  // ********************************************

  /// Film önerileri - Backend'teki logic'i taklit eder
  Future<List<Map<String, dynamic>>> getMovieRecommendations({
    required String userId,
  }) async {
    try {
      // Kullanıcının yüksek rating verdiği filmleri al
      final userHighRatedMovies = await _migrationService.getUserContents(
        contentType: ContentTypeEnum.MOVIE,
        logUserId: userId,
      );

      final movieList = userHighRatedMovies['contentList'] as List?;
      if (movieList == null || movieList.isEmpty) {
        // Eğer kullanıcının filmi yoksa, popüler filmleri döndür
        final popularMovies = await discoverMovies(page: 1, userId: userId);
        return List<Map<String, dynamic>>.from(popularMovies['contents'] ?? []);
      }

      // Random bir film seç
      final randomMovie = movieList[movieList.length ~/ 2];
      // ShowcaseContentModel 'id' değil 'contentId' alanına sahip
      final selectedContentId = randomMovie.contentId;

      // TMDB'den benzer filmleri al
      final response = await http.get(
        Uri.parse('$_tmdbBaseUrl/movie/$selectedContentId/recommendations'),
        headers: _tmdbHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recommendations = List<Map<String, dynamic>>.from(data['results'] ?? []);

        // User logs ile birleştir
        if (recommendations.isNotEmpty) {
          final movieIds = recommendations.map((movie) => movie['id'] as int).toList();
          final userLogs = await _getUserLogsForContents(userId, movieIds);

          for (var movie in recommendations) {
            final movieId = movie['id'];
            final userLog = userLogs[movieId];

            movie['user_is_favorite'] = userLog?['is_favorite'] ?? false;
            movie['user_is_consume_later'] = userLog?['is_consume_later'] ?? false;
            movie['user_rating'] = userLog?['rating'];
            movie['user_content_status_id'] = userLog?['content_status_id'];
          }
        }

        return recommendations;
      }
    } catch (e) {
      debugPrint('Error getting movie recommendations: $e');
    }

    return [];
  }

  // ********************************************
  // GENRE METHODS - Backend /getAllGenre endpoint
  // ********************************************

  /// TMDB'den film genre listesi al
  Future<List<Map<String, dynamic>>> getMovieGenres() async {
    try {
      final response = await http.get(
        Uri.parse('$_tmdbBaseUrl/genre/movie/list'),
        headers: _tmdbHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['genres'] ?? []);
      }
    } catch (e) {
      debugPrint('Error getting movie genres: $e');
    }

    return [];
  }

  /// IGDB'den oyun genre listesi al
  Future<List<Map<String, dynamic>>> getGameGenres() async {
    try {
      final response = await http.post(
        Uri.parse('$_igdbBaseUrl/genres'),
        headers: _igdbHeaders,
        body: 'fields id,name; limit 50; sort name asc;',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      debugPrint('Error getting game genres: $e');
    }

    return [];
  }

  // ********************************************
  // LANGUAGE METHODS - Backend /getAllLanguage endpoint
  // ********************************************

  /// TMDB'den dil listesi al
  Future<List<Map<String, dynamic>>> getMovieLanguages() async {
    try {
      final response = await http.get(
        Uri.parse('$_tmdbBaseUrl/configuration/languages'),
        headers: _tmdbHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      debugPrint('Error getting movie languages: $e');
    }

    return [];
  }

  // ********************************************
  // HELPER METHODS - Backend'teki user logs logic
  // ********************************************

  /// User logs'ları al - Backend'teki user logs query'sini taklit eder
  Future<Map<int, Map<String, dynamic>>> _getUserLogsForContents(
    String userId,
    List<int> contentIds,
  ) async {
    try {
      final userLogs = await _migrationService.client.from('user_content_log').select('content_id, is_favorite, is_consume_later, rating, content_status_id, review_id').eq('user_id', _migrationService.currentUserId!).inFilter('content_id', contentIds).order('date', ascending: false);

      final Map<int, Map<String, dynamic>> logsMap = {};
      for (var log in userLogs) {
        final contentId = log['content_id'] as int;
        if (!logsMap.containsKey(contentId)) {
          logsMap[contentId] = log;
        }
      }

      return logsMap;
    } catch (e) {
      debugPrint('Error getting user logs: $e');
      return {};
    }
  }

  // ********************************************
  // SEARCH METHODS - Backend /searchContent endpoint
  // ********************************************

  /// Content arama - Hem TMDB hem IGDB'de ara
  Future<Map<String, dynamic>> searchContent({
    required String query,
    required int contentTypeId,
    int page = 1,
    String? userId,
  }) async {
    try {
      if (contentTypeId == 1) {
        // Movie search
        final response = await http.get(
          Uri.parse('$_tmdbBaseUrl/search/movie?query=${Uri.encodeComponent(query)}&page=$page'),
          headers: _tmdbHeaders,
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final results = List<Map<String, dynamic>>.from(data['results'] ?? []);

          // User logs ile birleştir
          if (userId != null && results.isNotEmpty) {
            final movieIds = results.map((movie) => movie['id'] as int).toList();
            final userLogs = await _getUserLogsForContents(userId, movieIds);

            for (var movie in results) {
              final movieId = movie['id'];
              final userLog = userLogs[movieId];

              movie['user_is_favorite'] = userLog?['is_favorite'] ?? false;
              movie['user_is_consume_later'] = userLog?['is_consume_later'] ?? false;
              movie['user_rating'] = userLog?['rating'];
              movie['user_content_status_id'] = userLog?['content_status_id'];
            }
          }

          return {
            'contents': results,
            'total_pages': data['total_pages'],
          };
        }
      } else if (contentTypeId == 2) {
        // Game search
        final response = await http.post(
          Uri.parse('$_igdbBaseUrl/games'),
          headers: _igdbHeaders,
          body: 'fields id,name,summary,cover.image_id,first_release_date; search "$query"; limit 20; offset ${(page - 1) * 20};',
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is List) {
            final results = List<Map<String, dynamic>>.from(data);

            // User logs ile birleştir
            if (userId != null && results.isNotEmpty) {
              final gameIds = results.map((game) => game['id'] as int).toList();
              final userLogs = await _getUserLogsForContents(userId, gameIds);

              for (var game in results) {
                final gameId = game['id'];
                final userLog = userLogs[gameId];

                game['user_is_favorite'] = userLog?['is_favorite'] ?? false;
                game['user_is_consume_later'] = userLog?['is_consume_later'] ?? false;
                game['user_rating'] = userLog?['rating'];
                game['user_content_status_id'] = userLog?['content_status_id'];
              }
            }

            return {
              'contents': results,
              'total_pages': 10, // IGDB'de sayfa hesaplaması farklı
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Error searching content: $e');
    }

    return {'contents': [], 'total_pages': 0};
  }
}
