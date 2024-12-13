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
    int? movieId,
    required ContentTypeEnum contentType,
    required ContentStatusEnum? contentStatus,
    required double? rating,
    required bool isFavorite,
    required bool isConsumeLater,
    String? review,
  }) async {
    final ContentLogModel userLog = ContentLogModel(
      // TODO: id ve diğerleri. böyle ayrı ayrı olmak yerine 1 tane fonksiyon oluşturayım orada verilenlere göre mi loglayayım. ya da sadece log u dışarı çıkarayım.
      userID: user.id,
      // TODO: date postgresql tarafında yapılabilir.
      date: DateTime.now(),
      contentID: movieId ?? contentModel!.id,
      contentType: contentType,
      review: review,
    );

    if (movieId == null) {
      contentModel!.contentStatus = contentStatus;
      contentModel!.rating = rating;
      contentModel!.isFavorite = isFavorite;
      contentModel!.isConsumeLater = isConsumeLater;
    }
    userLog.contentStatus = contentStatus;
    userLog.rating = rating;
    userLog.isFavorite = isFavorite;
    userLog.isConsumeLater = isConsumeLater;
    userLog.review = review;

    await ServerManager().contentUserAction(contentLogModel: userLog);

    if (movieId == null) {
      notifyListeners();
    }
  }
}
