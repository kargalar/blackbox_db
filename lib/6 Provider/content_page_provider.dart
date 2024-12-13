import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
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
    int? contentId,
    required ContentTypeEnum contentType,
    ContentStatusEnum? contentStatus,
    double? rating,
    bool? isFavorite,
    bool? isConsumeLater,
    String? review,
  }) async {
    final ContentLogModel userLog = ContentLogModel(
      userID: user.id,
      contentID: contentId ?? contentModel!.id,
      contentType: contentType,
      contentStatus: contentStatus,
      rating: rating,
      isFavorite: isFavorite,
      isConsumeLater: isConsumeLater,
      review: review,
    );

    // eğer conentpage dışında gönderirse sanırım
    if (contentId == null) {
      if (contentStatus != null) {
        contentModel!.contentStatus = contentStatus;
      } else if (rating != null) {
        contentModel!.rating = rating;
      } else if (isFavorite != null) {
        contentModel!.isFavorite = isFavorite;
      } else if (isConsumeLater != null) {
        contentModel!.isConsumeLater = isConsumeLater;
      }

      await ServerManager().contentUserAction(contentLogModel: userLog);

      if (contentId == null) {
        notifyListeners();
      }
    }
  }
}
