import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ServerManager {
  ServerManager._privateConstructor();

  static final ServerManager _instance = ServerManager._privateConstructor();

  factory ServerManager() {
    return _instance;
  }

  static const String _baseUrl = 'http://localhost:3000';

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

  // get all movie for showcase with user id
  // ? bu kullanıcının tüm logladığı içeriklerin listesi
  Future<List<ShowcaseContentModel>> getUserExploreContent({
    required ContentTypeEnum? contentType,
    required int userId,
  }) async {
    var response = await dio.request(
      "$_baseUrl/exploreUser?user_id=$userId${contentType != null ? "&content_type_id=${contentType.index + 1}" : ""}",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }

  // get discover content
  Future getDiscoverMovie({
    required int userId,
    int? yearFilter,
  }) async {
    if (ExploreProvider().allGenres == null) {
      var response = await dio.request(
        "$_baseUrl/getAllGenre",
        options: Options(
          method: 'GET',
        ),
      );

      checkRequest(response);

      ExploreProvider().allGenres = (response.data as List).map((e) => GenreModel.fromJson(e)).toList();
    }

    String url = "$_baseUrl/discoverMovie?user_id=$userId";

    if (ExploreProvider().filteredGenreList.isNotEmpty) {
      String genreIds = ExploreProvider().filteredGenreList.map((e) => e.id.toString()).join(',');

      url += "&genre=$genreIds";
    }
    if (yearFilter != null) {
      url += "&year=$yearFilter";
    }
    url += "&page=${ExploreProvider().currentPageIndex}";

    var response = await dio.request(
      url,
      options: Options(
        method: 'GET',
      ),
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
    var response = await dio.request(
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
      options: Options(
        method: 'POST',
      ),
    );

    checkRequest(response);
  }

  Future<ContentModel> getContentDetail({
    required int contentId,
    required ContentTypeEnum contentType,
    int? userId,
  }) async {
    var response = await dio.request(
      "$_baseUrl/content_detail?content_id=$contentId&user_id=${userId ?? userID}&content_type_id=${contentType.index + 1}",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return ContentModel.fromJson(response.data);
  }
}
