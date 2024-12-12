import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider._privateConstructor();
  static final ProfileProvider _instance = ProfileProvider._privateConstructor();
  factory ProfileProvider() {
    return _instance;
  }

  int currentPageIndex = 1;
  late int totalPageIndex;

  List<GenreModel> filteredGenreList = [];
  List<GenreModel>? allGenres;

  List<ShowcaseContentModel> contentList = [];

  bool isLoadingPage = true;
  bool isLoadingContents = true;

  void getContent(ContentTypeEnum contentType) async {
    try {
      // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
      // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
      // TODO: contentType null ise farklı istek atacak
      if (!isLoadingPage) {
        isLoadingContents = true;
        notifyListeners();
      }

      var response = await ServerManager().getUserContents(
        contentType: contentType,
        userId: userID,
      );

      contentList = response['contentList'];
      // totalPageIndex = response['totalPages'];

      isLoadingPage = false;
      isLoadingContents = false;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
