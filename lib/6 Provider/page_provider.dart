import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralProvider with ChangeNotifier {
  GeneralProvider._privateConstructor();
  static final GeneralProvider _instance = GeneralProvider._privateConstructor();
  factory GeneralProvider() {
    return _instance;
  }

  int currentIndex = 0;
  String searchText = '';
  ContentTypeEnum searchFilter = ContentTypeEnum.MOVIE;
  ContentTypeEnum exploreContentType = ContentTypeEnum.MOVIE;
  String currentUserID = "";
  int contentID = 0;
  ContentTypeEnum contentPageContentTpye = ContentTypeEnum.MOVIE;

  void home() {
    currentIndex = 0;
    notifyListeners();
  }

  void search(String text) {
    searchText = text;
    currentIndex = 1;
    notifyListeners();
  }

  void explore(ContentTypeEnum contentType, BuildContext context) {
    // TODO: movie, book veya game e her tıkladığında tekrar yüklesin
    exploreContentType = contentType;
    currentIndex = 2;

    Provider.of<ExploreProvider>(context, listen: false).filteredGenreList = [];
    Provider.of<ExploreProvider>(context, listen: false).currentPageIndex = 1;
    Provider.of<ExploreProvider>(context, listen: false).isProfilePage = false;
    Provider.of<ExploreProvider>(context, listen: false).getContent(context: context, contentType: contentType);

    notifyListeners();
  }

  void profile(String userID) {
    currentUserID = userID;
    currentIndex = 3;
    notifyListeners();
  }

  void content(int contentID, ContentTypeEnum contentType) {
    this.contentID = contentID;
    contentPageContentTpye = contentType;
    currentIndex = 4;
    notifyListeners();
  }
}
