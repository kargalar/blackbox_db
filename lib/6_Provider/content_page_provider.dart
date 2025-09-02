import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:flutter/material.dart';

class ContentPageProvider with ChangeNotifier {
  static final ContentPageProvider _instance = ContentPageProvider._internal();

  factory ContentPageProvider() {
    return _instance;
  }

  ContentPageProvider._internal();

  ContentModel? contentModel;

  List<ReviewModel> reviewList = [];

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
      userId: loginUser!.id,
      contentID: contentId ?? contentModel!.id!,
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

      if (review != null) {
        reviewList.insert(
          0,
          ReviewModel(
            id: reviewList.length + 1,
            picturePath: loginUser!.picturePath,
            userName: loginUser!.username,
            userId: loginUser!.id,
            text: review,
            createdAt: DateTime.now(),
            rating: rating,
            isFavorite: isFavorite,
            likeCount: 0,
            commentCount: 0,
            isLikedByCurrentUser: false,
          ),
        );
      }

      notifyListeners();
    }

    await MigrationService().contentUserAction(contentLogModel: userLog);
  }
}
