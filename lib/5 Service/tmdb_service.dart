import 'package:blackbox_db/8%20Model/search_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TMDBService {
  TMDBService._privateConstructor();

  static final TMDBService _instance = TMDBService._privateConstructor();

  factory TMDBService() {
    return _instance;
  }
  var dio = Dio();

  final headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZTU0MDMxOWU1NTNhODYxZTJmOWQwYmQxMzdmMmY4MiIsIm5iZiI6MTczMTA5MDI3NC43OTYzNTI2LCJzdWIiOiI2NzEzYmI5Y2Q1Yjc5MjZlOTQ2ZmMxMmEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.FSK1_wcmID-PYmf6ufz7_ZQYA7tyz_Xi396lg5G3Hds'
  };

  // check request
  void checkRequest(Response response) {
    if (response.statusCode == 200) {
      // debugPrint(json.encode(response.data));
    } else {
      debugPrint(response.statusMessage);
    }
  }

  Future<List<SearchContentModel>> search(searchText) async {
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
