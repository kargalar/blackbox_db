import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';

class ExploreProvider with ChangeNotifier {
  ExploreProvider._privateConstructor();
  static final ExploreProvider _instance = ExploreProvider._privateConstructor();
  factory ExploreProvider() {
    return _instance;
  }

  int currentPageIndex = 1;
  late int totalPageIndex;

  List<GenreModel> filteredGenreList = [];
  List<GenreModel>? allGenres;

  List<ShowcaseContentModel> contentList = [];

  bool isLoadingPage = true;
  bool isLoadingContents = true;

  void getContent() async {
    try {
      // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
      // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
      // TODO: contentType null ise farklı istek atacak
      if (!isLoadingPage) {
        isLoadingContents = true;
        notifyListeners();
      }

      var response = await ServerManager().getDiscoverMovie(
        userId: userID,
      );
      contentList = response['contentList'];
      totalPageIndex = response['totalPages'];

      isLoadingPage = false;
      isLoadingContents = false;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
