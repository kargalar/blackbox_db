import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:flutter/material.dart';

class ManagerPanelProvider with ChangeNotifier {
  static final ManagerPanelProvider _instance = ManagerPanelProvider._internal();
  factory ManagerPanelProvider() {
    return _instance;
  }
  ManagerPanelProvider._internal();

  bool isLoading = true;

  int currentPageIndex = 1;
  late int totalPageIndex;

  List<ContentModel> contentList = [];

  List<Map<String, dynamic>> topActorsByMovieCount = [];
  List<Map<String, dynamic>> averageMovieRatingsByGenre = [];
  List<Map<String, dynamic>> averageMovieRatingsByYear = [];

  // ? contentId null ise contentPage de demek

  Future searchContent({String? searchText, required ContentTypeEnum contentType}) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    final response = await ServerManager().searchContent(
      query: searchText ?? "",
      contentType: contentType,
      page: currentPageIndex,
    );

    contentList = response['contentList'];
    totalPageIndex = response['totalPages'];

    isLoading = false;
    notifyListeners();
  }

  Future getStatistics() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    try {
      // TODO: veriler paginationa ve intervala ygun hazırlandı düzenlenebilir
      topActorsByMovieCount = await ServerManager().getTopActorsByMovieCount(
        page: 1,
        limit: 10,
        interval: "1 week",
      );

      averageMovieRatingsByGenre = await ServerManager().getAverageMovieRatingsByGenre(
        page: 1,
        limit: 10,
        interval: "1 week",
      );
      averageMovieRatingsByYear = await ServerManager().getAverageMovieRatingsByYear(
        page: 1,
        limit: 10,
        interval: "1 week",
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
