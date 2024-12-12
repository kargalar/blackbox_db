import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider._privateConstructor();
  static final ProfileProvider _instance = ProfileProvider._privateConstructor();
  factory ProfileProvider() {
    return _instance;
  }

  // int currentPageIndex = 1;
  // late int totalPageIndex;

  // List<GenreModel> filteredGenreList = [];
  // List<GenreModel>? allGenres;

  // List<ShowcaseContentModel> contentList = [];

  // bool isLoadingPage = true;
  // bool isLoadingContents = true;

  // void getContent(ContentTypeEnum contentType) async {
  //   try {
  //     // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
  //     // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
  //     // TODO: contentType null ise farklı istek atacak
  //     if (!isLoadingPage) {
  //       isLoadingContents = true;
  //       notifyListeners();
  //     }

  //     var response = await ServerManager().getUserContents(
  //       contentType: contentType,
  //       userId: userID,
  //     );

  //     contentList = response['contentList'];
  //     // totalPageIndex = response['totalPages'];

  //     isLoadingPage = false;
  //     isLoadingContents = false;

  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}
