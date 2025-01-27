import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/genre_model.dart';
import 'package:blackbox_db/8_Model/language_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreProvider with ChangeNotifier {
  ExploreProvider._privateConstructor();
  static final ExploreProvider _instance = ExploreProvider._privateConstructor();
  factory ExploreProvider() {
    return _instance;
  }

  int currentPageIndex = 1;
  late int totalPageIndex;

  List<GenreModel> genreFilteredList = [];
  LanguageModel? languageFilter;

  List<GenreModel>? allMovieGenres;
  List<GenreModel>? allGameGenres;
  List<LanguageModel>? allMovieLanguage;
  // List<LanguageModel>? allGameLanguage;

  // rating filter

  List<ShowcaseContentModel> contentList = [];

  bool isLoadingPage = true;
  bool isLoadingContents = true;

  int? profileUserID;

  void getContent({required BuildContext context}) async {
    try {
      // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
      // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
      // TODO: contentType null ise farklı istek atacak
      if (!isLoadingPage) {
        isLoadingContents = true;
        notifyListeners();
      }

      late dynamic response;

      if (profileUserID != null) {
        response = await ServerManager().getUserContents(
          contentType: context.read<ProfileProvider>().contentType,
          logUserId: profileUserID!,
        );
      } else {
        if (context.read<GeneralProvider>().exploreContentType == ContentTypeEnum.MOVIE) {
          response = await ServerManager().getDiscoverMovie(
            userId: loginUser!.id,
          );
        } else if (context.read<GeneralProvider>().exploreContentType == ContentTypeEnum.GAME) {
          response = await ServerManager().getDiscoverGame(
            userId: loginUser!.id,
          );
        }
      }

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
