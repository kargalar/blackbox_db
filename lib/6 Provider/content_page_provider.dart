import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:flutter/material.dart';

class ContentPageProvider with ChangeNotifier {
  ContentModel? contentModel;

  void consume() {
    if (contentModel!.contentStatus == ContentStatusEnum.CONSUMED) {
      contentModel!.contentStatus = null;
    } else {
      contentModel!.contentStatus = ContentStatusEnum.CONSUMED;
    }

    notifyListeners();
  }

  void favorite() {
    contentModel!.isFavorite = !contentModel!.isFavorite;

    notifyListeners();
  }

  void consumeLater() {
    contentModel!.isConsumeLater = !contentModel!.isConsumeLater;

    notifyListeners();
  }

  void rate(double rating) {
    // kaydırırken her sefeirnde kaydetmemek için kullanıcı kaydırmayı bitirdiği zaman göderilsin.
    contentModel!.rating = rating;

    notifyListeners();
  }
}
