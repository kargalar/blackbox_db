import 'package:blackbox_db/1_Core/helper.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:blackbox_db/8_Model/user_model.dart';
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

  List<UserModel> userList = [];

  Future searchContent({String? searchText, required ContentTypeEnum contentType}) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    final response = await ServerManager().searchContent(
      query: searchText ?? "",
      contentType: contentType,
      page: currentPageIndex,
    );

    contentList = response['contentList'];
    totalPageIndex = response['totalPages'];

    isLoading = false;
    notifyListeners();
  }

  // get all user
  Future getAllUser() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    final response = await ServerManager().getAllUser();

    userList = response;

    isLoading = false;
    notifyListeners();
  }

  // delete user
  Future deleteUser({required int userID}) async {
    // TODO: are you sure dialog
    Helper().getDialog(
      message: "Are you sure? This user will be deleted.",
      onAccept: () async {
        await ServerManager().deleteUser(userID: userID);
        userList.removeWhere((element) => element.id == userID);

        notifyListeners();
      },
    );
  }
}
