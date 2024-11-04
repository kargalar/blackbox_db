import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';

class AppbarProvider with ChangeNotifier {
  int currentIndex = 0;
  String searchText = '';
  ContentTypeEnum exploreContentType = ContentTypeEnum.MOVIE;
  String currentUserID = "";

  void home() {
    currentIndex = 0;
    notifyListeners();
  }

  void profile(String userID) {
    currentUserID = userID;
    currentIndex = 3;
    notifyListeners();
  }

  void search(String text) {
    searchText = text;
    currentIndex = 1;
    notifyListeners();
  }

  void explore(ContentTypeEnum contentType) {
    exploreContentType = contentType;
    currentIndex = 2;
    notifyListeners();
  }
}
