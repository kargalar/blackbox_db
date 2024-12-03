import 'package:blackbox_db/8%20Model/search_movie_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class IGDBService {
  IGDBService._privateConstructor();

  static final IGDBService _instance = IGDBService._privateConstructor();

  factory IGDBService() {
    return _instance;
  }
  var dio = Dio();

  final headers = {
    'accept': 'application/json',
    'Client-ID': 'bq60331ycb0t8lvffnmhwkoooqzecp',
    'Authorization': 'Bearer pbac2y2iap5wlb8f49cpfmcmqal6lu',
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
  Future<List<SearchContentModel>> search(searchText) async {
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
