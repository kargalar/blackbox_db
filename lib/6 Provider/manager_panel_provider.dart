import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
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

  // ? contentId null ise contentPage de demek

  Future getAllContent({
    required ContentTypeEnum contentType,
    required int page,
  }) async {
    if (!isLoading) return;
    {
      isLoading = true;
      notifyListeners();
    }

    final response = await ServerManager().getAllContent(
      contentType: ContentTypeEnum.MOVIE,
      page: currentPageIndex,
    );

    contentList = response['contentList'];
    totalPageIndex = response['totalPages'];

    isLoading = false;
    notifyListeners();
  }
}
