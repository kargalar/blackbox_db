import 'package:blackbox_db/8_Model/search_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBService {
  TMDBService._privateConstructor();

  static final TMDBService _instance = TMDBService._privateConstructor();

  factory TMDBService() {
    return _instance;
  }
  var dio = Dio();

  final headers = {'accept': 'application/json', 'Authorization': dotenv.env['TMDB_Authorization']};

  // check request
  void checkRequest(Response response) {
    if (response.statusCode == 200) {
      // debugPrint(json.encode(response.data));
    } else {
      debugPrint(response.statusMessage);
    }
  }

  Future<List<SearchContentModel>> search(String? searchText) async {
    final url = 'https://api.themoviedb.org/3/search/movie?query=$searchText&include_adult=false&language=en-US&page=1';

    final response = await Dio().get(
      url,
      options: Options(
        headers: headers,
      ),
    );

    checkRequest(response);

    return SearchContentModel.fromJsonTMDBList(response.data);
  }
}
