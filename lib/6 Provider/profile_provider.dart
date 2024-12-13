import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider._privateConstructor();
  static final ProfileProvider _instance = ProfileProvider._privateConstructor();
  factory ProfileProvider() {
    return _instance;
  }

  ContentTypeEnum contentType = ContentTypeEnum.MOVIE;

  int currentPageIndex = 0;

// !!!!!!!!!!!!!!!!!!!!
// TODO:
  // eğer profiline gidilen sayfakendinin değilse olacak olan usermodel burada tutulacak ve gerekli yerlede buradan kullanıalcak. bu sayfaded başka profiller ziyaret mümkün oalcak. sadece profile pictırelardan gidilior istek orad atıarbilir belki. veya normal profile page de atlsnı sa

  void goHomePage(context) async {
    {
      currentPageIndex = 0;
      notifyListeners();
    }
  }

  void goMoviePage(BuildContext context) async {
    {
      currentPageIndex = 1;
      contentType = ContentTypeEnum.MOVIE;
      Provider.of<ExploreProvider>(context, listen: false).currentPageIndex = 1;

      Provider.of<ExploreProvider>(context, listen: false).isProfilePage = true;
      Provider.of<ExploreProvider>(context, listen: false).getContent(context: context);

      notifyListeners();
    }
  }

  void goGamePage(context) async {
    {
      currentPageIndex = 2;

      contentType = ContentTypeEnum.GAME;
      Provider.of<ExploreProvider>(context, listen: false).currentPageIndex = 1;

      Provider.of<ExploreProvider>(context, listen: false).isProfilePage = true;
      Provider.of<ExploreProvider>(context, listen: false).getContent(context: context);

      notifyListeners();
    }
  }

  void goReviewPage(context) async {
    {
      currentPageIndex = 3;

      notifyListeners();
    }
  }

  void goListPage(context) async {
    {
      currentPageIndex = 4;

      notifyListeners();
    }
  }

  void goNetworkPage(context) async {
    {
      currentPageIndex = 5;

      notifyListeners();
    }
  }

  void goActivityPage(context) async {
    {
      currentPageIndex = 6;

      notifyListeners();
    }
  }
}
