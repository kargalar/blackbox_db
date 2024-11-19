import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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
      debugPrint(json.encode(response.data));
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

  // get all content
  Future<List<ContentModel>> getAllContent() async {
    var response = await dio.request(
      "$_baseUrl/content",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => ContentModel.fromJson(e)).toList();
  }

  // get all content fow showcase with user id
  Future<List<ShowcaseContentModel>> getExploreContent({
    required ContentTypeEnum? contentType,
    required String userId,
  }) async {
    var response = await dio.request(
      "$_baseUrl/explore?user_id=$userId${contentType != null ? "&content_type_id=${contentType.index + 1}" : ""}",
      options: Options(
        method: 'GET',
      ),
    );

    checkRequest(response);

    return (response.data as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();
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
}
