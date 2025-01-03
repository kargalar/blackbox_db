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

  Future addContentItem() async {
    contentList.insert(
      0,
      ContentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: "",
        contentType: ContentTypeEnum.MOVIE,
        favoriCount: -999, // bu sayede yeni öğe mi onu kontrol ediyorum
      ),
    );

    notifyListeners();
  }

  Future addContent({required ContentModel contentModel}) async {
    int newContentID = await ServerManager().addContent(contentModel: contentModel);

    int index = contentList.indexWhere((element) => element.id == contentModel.id);

    contentList.removeWhere((element) => element.id == contentModel.id);

    contentList.insert(
      index,
      ContentModel(
        id: newContentID,
        title: contentModel.title,
        contentType: contentModel.contentType,
        favoriCount: contentModel.favoriCount,
      ),
    );

    notifyListeners();
  }

  Future updateContent({required ContentModel contentModel}) async {
    Helper().getDialog(
      message: "Are you sure? This content will be updated.",
      onAccept: () async {
        await ServerManager().updateContent(contentModel: contentModel);

        notifyListeners();
      },
    );
  }

  Future deleteContent({required int contentID}) async {
    Helper().getDialog(
      message: "Are you sure? This content will be deleted.",
      onAccept: () async {
        await ServerManager().deleteContent(contentID: contentID);
        contentList.removeWhere((element) => element.id == contentID);

        notifyListeners();
      },
    );
  }

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
