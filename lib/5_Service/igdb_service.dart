import 'package:blackbox_db/8_Model/search_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IGDBService {
  IGDBService._privateConstructor();

  static final IGDBService _instance = IGDBService._privateConstructor();

  factory IGDBService() {
    return _instance;
  }
  var dio = Dio();

  final headers = {
    'accept': 'application/json',
    'Client-ID': dotenv.env['IGDB_Client_id'],
    'Authorization': dotenv.env['IGDB_Authorization'],
  };

  // check request
  void checkRequest(Response response) {
    if (response.statusCode == 200) {
      // debugPrint(json.encode(response.data));
    } else {
      debugPrint(response.statusMessage);
    }
  }

  // get all genres
  Future<List<SearchContentModel>> search(String? searchText) async {
    final url = 'https://api.igdb.com/v4/games';

    final response = await Dio().post(
      url,
      options: Options(
        headers: headers,
      ),
      // TODO: şimdilik sadece pc oyunları geliyor ileride platform seçimi yapılacak
      // data: jsonEncode({
      //   'fields': 'id,cover.image_id,name,summary,first_release_date',
      //   'search': searchText,
      //   'where': 'version_parent = null & category = 0 & platforms = (6)',
      //   'limit': 20,
      // }),

      data: 'fields id,cover.image_id,name,summary,first_release_date; search "$searchText"; where version_parent = null & category = 0 & platforms = (6); limit 20;',
    );

    checkRequest(response);

    return SearchContentModel.fromJsonIGDBList(response.data);
  }
}
