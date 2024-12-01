import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
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

  Future<void> consume({int? contentId}) async {
    if (contentId != null) {
      // TODO: aynı filme 2. defa log atmak istediğinde tekrar get detaile gerek olmamalı
      contentModel = await ServerManager().getContentDetail(contentId: contentId);
    }

    final ContentLogModel userLog = ContentLogModel(
      // TODO: id ve diğerleri. böyle ayrı ayrı olmak yerine 1 tane fonksiyon oluşturayım orada verilenlere göre mi loglayayım. ya da sadece log u dışarı çıkarayım.
      userID: userID,
      // TODO: date postgresql tarafında yapılabilir.
      date: DateTime.now(),
      contentID: contentModel!.id,
      contentType: contentModel!.contentType,
      // contentStatus: ContentStatusEnum.CONSUMED,
      // rating: 3.5,
      // isFavorite: false,
      // isConsumeLater: false,
      // review: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps",
    );

    if (contentModel!.contentStatus == ContentStatusEnum.CONSUMED) {
      if (contentId == null) contentModel!.contentStatus = null;
      userLog.contentStatus = null;
    } else {
      if (contentId == null) contentModel!.contentStatus = ContentStatusEnum.CONSUMED;
      userLog.contentStatus = ContentStatusEnum.CONSUMED;
    }

    await ServerManager().contentUserAction(contentLogModel: userLog);

    if (contentId != null) {
      contentModel = null;
    } else {
      notifyListeners();
    }
  }

  void favorite() {
    contentModel!.isFavorite = !contentModel!.isFavorite;

    notifyListeners();
  }

  void consumeLater() {
    contentModel!.isConsumeLater = !contentModel!.isConsumeLater;

    notifyListeners();
  }

  void rating(double rating) {
    // kaydırırken her sefeirnde kaydetmemek için kullanıcı kaydırmayı bitirdiği zaman göderilsin.
    contentModel!.rating = rating;

    notifyListeners();
  }

  // TODO: review
}
