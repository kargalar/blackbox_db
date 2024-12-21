import 'package:blackbox_db/1%20Core/Enums/status_enum.dart';
import 'package:blackbox_db/1%20Core/helper.dart';
import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/language_model.dart';
import 'package:blackbox_db/8%20Model/user_model.dart';
import 'package:blackbox_db/8%20Model/user_review_model.dart';
import 'package:blackbox_db/8%20Model/review_model.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ServerManager {
  ServerManager._privateConstructor();

  static final ServerManager _instance = ServerManager._privateConstructor();

  factory ServerManager() {
    return _instance;
  }

  static const String _baseUrl = 'http://localhost:3000';
  // static const String _baseUrl = 'https://blackboxdb-d42413898246.herokuapp.com';

  var dio = Dio();

  // --------------------------------------------

  // check request
  void checkRequest(Response response) {
    if (response.statusCode == 200) {
      // debugPrint(json.encode(response.data));
    } else {
      debugPrint(response.statusMessage);
    }
  }

  // ********************************************

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl/login",
        data: {
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Show error message to the user
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: 'Email not found',
        );
      } else if (e.response?.statusCode == 401) {
        // Show error message to the user
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: 'Incorrect password',
        );
      } else {
        // Handle other errors
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: 'An error occurred: ${e.message}',
        );
      }
      return null;
    }
  }

  Future<UserModel?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl/register",
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      checkRequest(response);

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: 'User already exists',
        );
      } else {
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: 'An error occurred: ${e.message}',
        );
      }
      return null;
    }
  }

  Future getUserInfo({
    required int userId,
  }) async {
    var response = await dio.get(
      "$_baseUrl/getUserInfo",
      queryParameters: {
        'user_id': userId,
      },
    );

    checkRequest(response);

    return UserModel.fromJson(response.data);
  }

  // get all movie for showcase with user id
  // ? bu kullanıcının tüm logladığı içeriklerin listesi
  Future getUserContents({
    required ContentTypeEnum contentType,
    required int logUserId,
  }) async {
    var response = await dio.get(
      "$_baseUrl/userContents",
      queryParameters: {
        'user_id': loginUser!.id,
        'log_user_id': logUserId,
        'content_type_id': contentType.index + 1,
        'page': ExploreProvider().currentPageIndex,
      },
    );

    checkRequest(response);

    var data = response.data as Map<String, dynamic>;
    var contentList = (data['contents'] as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();
    var totalPages = data['total_pages'] as int;

    return {
      'contentList': contentList,
      'totalPages': totalPages,
    };
  }

  // get all language
  Future<List<LanguageModel>> getAllLanguage(ContentTypeEnum contentType) async {
    var response = await dio.get(
      "$_baseUrl/getAllLanguage",
      queryParameters: {
        'content_type_id': contentType.index + 1,
      },
    );

    checkRequest(response);

    return (response.data as List).map((e) => LanguageModel.fromJson(e)).toList();
  }

  // get all genre
  Future<List<GenreModel>> getAllGenre(ContentTypeEnum contentType) async {
    var response = await dio.get(
      "$_baseUrl/getAllGenre",
      queryParameters: {
        'content_type_id': contentType.index + 1,
      },
    );

    checkRequest(response);

    return (response.data as List).map((e) => GenreModel.fromJson(e)).toList();
  }

  // get discover content
  Future getDiscoverMovie({
    required int userId,
  }) async {
    if (ExploreProvider().allMovieGenres == null || ExploreProvider().allMovieLanguage == null) {
      ExploreProvider().allMovieGenres = await getAllGenre(ContentTypeEnum.MOVIE);
      ExploreProvider().allMovieLanguage = await getAllLanguage(ContentTypeEnum.MOVIE);
    }

    String url = "$_baseUrl/discoverMovie?user_id=$userId";

    if (ExploreProvider().genreFilteredList.isNotEmpty) {
      String genreIds = ExploreProvider().genreFilteredList.map((e) => e.id.toString()).join(',');

      url += "&with_genres=$genreIds";
    }
    if (ExploreProvider().languageFilter != null) {
      String languageISO = ExploreProvider().languageFilter!.iso!;

      url += "&with_original_language=$languageISO";
    }

    // if (yearFilter != null) {
    //   url += "&year=$yearFilter";
    // }
    url += "&page=${ExploreProvider().currentPageIndex}";

    var response = await dio.get(
      url,
    );

    checkRequest(response);

    var data = response.data as Map<String, dynamic>;
    var contentList = (data['contents'] as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();
    var totalPages = data['total_pages'] as int;

    return {
      'contentList': contentList,
      'totalPages': totalPages,
    };
  }

  // get discover Game
  Future getDiscoverGame({
    required int userId,
  }) async {
    if (ExploreProvider().allGameGenres == null
        //  || ExploreProvider().allGameLanguage == null
        ) {
      ExploreProvider().allGameGenres = await getAllGenre(ContentTypeEnum.GAME);
      // ExploreProvider().allGameLanguage = await getAllLanguage(ContentTypeEnum.GAME);
    }

    String url = "$_baseUrl/discoverGame?user_id=$userId";

    if (ExploreProvider().genreFilteredList.isNotEmpty) {
      String genreIds = ExploreProvider().genreFilteredList.map((e) => e.id.toString()).join(',');

      url += "&genre=$genreIds";
    }

    // if (ExploreProvider().languageFilter != null) {
    //   url += "&language=${ExploreProvider().languageFilter!.id}";
    // }
    // if (yearFilter != null) {
    //   url += "&year=$yearFilter";
    // }

    url += "&offset=${ExploreProvider().currentPageIndex * 20}";

    var response = await dio.get(
      url,
    );
    checkRequest(response);

    var data = response.data as Map<String, dynamic>;
    var contentList = (data['contents'] as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();
    var totalPages = data['total_pages'] as int;

    return {
      'contentList': contentList,
      'totalPages': totalPages,
    };
  }

  //conent_user_action
  Future<void> contentUserAction({
    required ContentLogModel contentLogModel,
  }) async {
    var response = await dio.post(
      "$_baseUrl/content_user_action",
      data: {
        'user_id': contentLogModel.userID,
        'content_id': contentLogModel.contentID,
        'content_status_id': contentLogModel.contentStatus == null ? null : contentLogModel.contentStatus!.index + 1,
        'content_type_id': contentLogModel.contentType.index + 1,
        'rating': contentLogModel.rating == 0 ? null : contentLogModel.rating,
        'is_favorite': contentLogModel.isFavorite,
        'is_consume_later': contentLogModel.isConsumeLater,
        'review': contentLogModel.review,
      },
    );

    checkRequest(response);
  }

  Future<ContentModel> getContentDetail({
    required int contentId,
    required ContentTypeEnum contentType,
    int? userId,
  }) async {
    var response = await dio.get(
      "$_baseUrl/content_detail",
      queryParameters: {
        'user_id': userId ?? loginUser!.id,
        'content_id': contentId,
        'content_type_id': contentType.index + 1,
      },
    );

    checkRequest(response);

    return ContentModel.fromJson(response.data);
  }

  Future<List<ReviewModel>> getContentReviews({
    required int contentId,
  }) async {
    var response = await dio.get(
      "$_baseUrl/content_reviews",
      queryParameters: {
        'content_id': contentId,
      },
    );

    checkRequest(response);

    return (response.data as List).map((e) => ReviewModel.fromJson(e)).toList();
  }

  Future<List<UserReviewModel>> getUserReviews({
    required int contentId,
  }) async {
    var response = await dio.get(
      "$_baseUrl/user_reviews",
      queryParameters: {
        'content_id': contentId,
      },
    );

    checkRequest(response);

    return (response.data as List).map((e) => UserReviewModel.fromJson(e)).toList();
  }

  Future getTrendContents({
    required ContentTypeEnum contentType,
  }) async {
    var response = await dio.get(
      "$_baseUrl/getTrendContent",
      queryParameters: {
        'content_type_id': contentType.index + 1,
        'user_id': loginUser!.id,
      },
    );

    checkRequest(response);

    var contentList = (response.data as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

    return {
      'contentList': contentList,
    };
  }

  // get friend last activites
  Future getFriendActivities({
    required ContentTypeEnum contentType,
  }) async {
    var response = await dio.get(
      "$_baseUrl/friendsActivity",
      queryParameters: {
        'content_type_id': contentType.index + 1,
        'user_id': loginUser!.id,
      },
    );

    checkRequest(response);

    var contentList = (response.data as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

    return {
      'contentList': contentList,
    };
  }

  // get recommended movies for user
  Future getRecommendedContents({
    required int userId,
    required ContentTypeEnum contentType,
  }) async {
    var response = await dio.get(
      "$_baseUrl/recommendContent",
      queryParameters: {
        'content_type_id': contentType.index + 1,
        'user_id': userId,
      },
    );

    checkRequest(response);

    var contentList = (response.data as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

    return {
      'contentList': contentList,
    };
  }

  // search content
  Future searchContent({
    required String query,
    required ContentTypeEnum contentType,
    required int page,
  }) async {
    var response = await dio.get(
      "$_baseUrl/searchContent",
      queryParameters: {
        'query': query,
        'content_type_id': contentType.index + 1,
        'page': page,
      },
    );

    checkRequest(response);

    var data = response.data as Map<String, dynamic>;
    var contentList = (data['contents'] as List).map((e) => ContentModel.fromJson(e)).toList();
    var totalPages = data['total_pages'] as int;

    return {
      'contentList': contentList,
      'totalPages': totalPages,
    };
  }
}
