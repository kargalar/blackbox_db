import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/movie_log_model.dart';
import 'package:blackbox_db/8%20Model/movie_model.dart';
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

  // get all genres
  Future<List<GenreModel>> getGenres() async {
    var response = await dio.request(
      "$_baseUrl/genre",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => GenreModel.fromJson(e)).toList();
  }

  // get all movie
  Future<List<MovieModel>> getAllMovie() async {
    var response = await dio.request(
      "$_baseUrl/movie",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => MovieModel.fromJson(e)).toList();
  }

  // get all movie for showcase with user id
  Future<List<ShowcaseMovieModel>> getExploreMovie({
    required ContentTypeEnum? contentType,
    required int userId,
  }) async {
    var response = await dio.request(
      "$_baseUrl/explore?user_id=$userId${contentType != null ? "&content_type_id=${contentType.index + 1}" : ""}",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => ShowcaseMovieModel.fromJson(e)).toList();
  }

  // add genre
  Future<void> addGenre(String name) async {
    var response = await dio.request(
      "$_baseUrl/genre",
      data: {
        'name': name,
      },
      options: Options(
        method: 'POST',
      ),
    );

    checkRequest(response);
  }

  //conent_user_action
  Future<void> movieUserAction({
    required MovieLogModel movieLogModel,
  }) async {
    var response = await dio.request(
      "$_baseUrl/movie_user_action",
      data: {
        'user_id': movieLogModel.userID,
        'movie_id': movieLogModel.movieID,
        'content_status_id': movieLogModel.contentStatus == null ? null : movieLogModel.contentStatus!.index + 1,
        'rating': movieLogModel.rating == 0 ? null : movieLogModel.rating,
        'is_favorite': movieLogModel.isFavorite,
        'is_consume_later': movieLogModel.isConsumeLater,
        'review': movieLogModel.review,
      },
      options: Options(
        method: 'POST',
      ),
    );

    checkRequest(response);
  }

  Future<MovieModel> getMovieDetail({
    required int movieId,
    int? userId,
  }) async {
    var response = await dio.request(
      "$_baseUrl/movie_detail?movie_id=$movieId&user_id=${userId ?? userID}",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return MovieModel.fromJson(response.data);
  }
}
