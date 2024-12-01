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
    required ContentStatusEnum? contentStatus,
    required double? rating,
    required bool isFavorite,
    required bool isConsumeLater,
  }) async {
    final ContentLogModel userLog = ContentLogModel(
      // TODO: id ve diğerleri. böyle ayrı ayrı olmak yerine 1 tane fonksiyon oluşturayım orada verilenlere göre mi loglayayım. ya da sadece log u dışarı çıkarayım.
      userID: userID,
      // TODO: date postgresql tarafında yapılabilir.
      date: DateTime.now(),
      contentID: contentId ?? contentModel!.id,
      contentType: contentType,
      // review: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps",
    );

    if (contentId == null) {
      contentModel!.contentStatus = contentStatus;
      contentModel!.rating = rating;
      contentModel!.isFavorite = isFavorite;
      contentModel!.isConsumeLater = isConsumeLater;
    }
    userLog.contentStatus = contentStatus;
    userLog.rating = rating;
    userLog.isFavorite = isFavorite;
    userLog.isConsumeLater = isConsumeLater;

    await ServerManager().contentUserAction(contentLogModel: userLog);

    if (contentId == null) {
      notifyListeners();
    }
  }

  // void favorite() {
  //   contentModel!.isFavorite = !contentModel!.isFavorite;

  //   notifyListeners();
  // }

  // void consumeLater() {
  //   contentModel!.isConsumeLater = !contentModel!.isConsumeLater;

  //   notifyListeners();
  // }

  // void rating(double rating) {
  //   // kaydırırken her sefeirnde kaydetmemek için kullanıcı kaydırmayı bitirdiği zaman göderilsin.
  //   contentModel!.rating = rating;

  //   notifyListeners();
  // }

  // TODO: review
}
