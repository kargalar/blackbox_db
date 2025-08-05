import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider._privateConstructor();
  static final ProfileProvider _instance = ProfileProvider._privateConstructor();
  factory ProfileProvider() {
    return _instance;
  }

  UserModel? user;

  ContentTypeEnum contentType = ContentTypeEnum.MOVIE;

  int currentPageIndex = 0;

  bool isLoading = true;

  void getUserInfo(String userId) async {
    currentPageIndex = 0;

    isLoading = true;
    notifyListeners();

    user = await MigrationService().getUserInfo(userId: userId);

    isLoading = false;
    notifyListeners();
  }

  void goHomePage(BuildContext context) async {
    {
      Provider.of<ExploreProvider>(context, listen: false).profileUserID = user!.id;
      currentPageIndex = 0;
      notifyListeners();
    }
  }

  void goMoviePage(BuildContext context) async {
    {
      contentType = ContentTypeEnum.MOVIE;
      Provider.of<ExploreProvider>(context, listen: false).currentPageIndex = 1;

      Provider.of<ExploreProvider>(context, listen: false).profileUserID = user!.id;
      Provider.of<ExploreProvider>(context, listen: false).getContent(context: context);

      notifyListeners();
    }
  }

  void goGamePage(BuildContext context) async {
    {
      currentPageIndex = 2;

      contentType = ContentTypeEnum.GAME;
      Provider.of<ExploreProvider>(context, listen: false).currentPageIndex = 1;

      Provider.of<ExploreProvider>(context, listen: false).profileUserID = user!.id;
      Provider.of<ExploreProvider>(context, listen: false).getContent(context: context);

      notifyListeners();
    }
  }

  void goReviewPage(BuildContext context) async {
    {
      currentPageIndex = 3;

      notifyListeners();
    }
  }

  void goListPage(BuildContext context) async {
    {
      currentPageIndex = 4;

      notifyListeners();
    }
  }

  void goNetworkPage(BuildContext context) async {
    {
      currentPageIndex = 5;

      notifyListeners();
    }
  }

  void goActivityPage(BuildContext context) async {
    {
      currentPageIndex = 6;

      notifyListeners();
    }
  }
}
