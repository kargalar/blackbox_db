import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
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

  // // get all genres
  // Future<List<GenreModel>> getGenres() async {
  //   var response = await dio.request(
  //     "$_baseUrl/genre",
  //     options: Options(
  //       method: 'GET',
  //     ),
  //   );

  //   checkRequest(response);

  //   return (response.data as List).map((e) => GenreModel.fromJson(e)).toList();
  // }

  // // get all movie
  // Future<List<ContentModel>> getAllMovie() async {
  //   var response = await dio.request(
  //     "$_baseUrl/movie",
  //     options: Options(
  //       method: 'GET',
  //     ),
  //   );

  //   checkRequest(response);

  //   return (response.data as List).map((e) => ContentModel.fromJson(e)).toList();
  // }

  // get all movie for showcase with user id
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
  Future<List<ShowcaseContentModel>> getDiscoverContent({
    required ContentTypeEnum? contentType,
    required int userId,
    String? genreFilter,
    int? yearFilter,
  }) async {
    String url = "$_baseUrl/discoverMovie?user_id=$userId";

    // Add filters
    if (contentType != null) {
      url += "&content_type_id=${contentType.index + 1}";
    }
    if (genreFilter != null) {
      url += "&with_genres=$genreFilter";
    }
    if (yearFilter != null) {
      url += "&primary_release_year=$yearFilter";
    }

    var response = await dio.request(
      url,
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }

  // // add genre
  // Future<void> addGenre(String name) async {
  //   var response = await dio.request(
  //     "$_baseUrl/genre",
  //     data: {
  //       'name': name,
  //     },
  //     options: Options(
  //       method: 'POST',
  //     ),
  //   );

  //   checkRequest(response);
  // }

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
