import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:flutter/material.dart';

class ContentPageProvider with ChangeNotifier {
  static final ContentPageProvider _instance = ContentPageProvider._internal();

  factory ContentPageProvider() {
    return _instance;
  }

  ContentPageProvider._internal();

  ContentModel? contentModel;

  // ? contentId null ise contentPage de demek

  Future<void> contentUserAction({
    required ContentTypeEnum contentType,
    int? contentId,
    required ContentStatusEnum? contentStatus,
    required double? rating,
    required bool isFavorite,
    required bool isConsumeLater,
    String? review,
  }) async {
    final ContentLogModel userLog = ContentLogModel(
      userID: loginUser!.id,
      contentID: contentId ?? contentModel!.id,
      contentType: contentType,
      contentStatus: contentStatus,
      rating: rating,
      isFavorite: isFavorite,
      isConsumeLater: isConsumeLater,
      review: review,
    );

    // eğer content page de ise değişiklikleri kullanıcıya göstermek için
    if (contentId == null) {
      contentModel!.isConsumeLater = isConsumeLater;
      contentModel!.isFavorite = isFavorite;
      contentModel!.contentStatus = contentStatus;
      contentModel!.rating = rating;
      notifyListeners();
    }

    await ServerManager().contentUserAction(contentLogModel: userLog);
  }
}
