import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  PageProvider._privateConstructor();
  static final PageProvider _instance = PageProvider._privateConstructor();
  factory PageProvider() {
    return _instance;
  }

  int currentIndex = 0;
  String searchText = '';
  ContentTypeEnum searchFilter = ContentTypeEnum.MOVIE;
  ContentTypeEnum exploreContentType = ContentTypeEnum.MOVIE;
  String currentUserID = "";
  int contentID = 0;
  ContentTypeEnum contentPageContentTpye = ContentTypeEnum.MOVIE;

  // Discover
  int currentPageIndex = 1;
  late int totalPageIndex;
  // genre tmdb den veya igdb den alınacak
  List<GenreModel> filteredGenreList = [];
  List<GenreModel>? allGenres;

  void home() {
    currentIndex = 0;
    notifyListeners();
  }

  void search(String text) {
    searchText = text;
    currentIndex = 1;
    notifyListeners();
  }

  void explore(ContentTypeEnum contentType) {
    // TODO: movie, book veya game e her tıkladığında tekrar yüklesin
    exploreContentType = contentType;
    currentIndex = 2;
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
