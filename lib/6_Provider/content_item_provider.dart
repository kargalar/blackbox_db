import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class ContentItemProvider with ChangeNotifier {
  ContentItemProvider({
    required this.showcaseContentModel,
  });

  ShowcaseContentModel showcaseContentModel;

  // TODO:
  Future consume() async {
    showcaseContentModel.contentStatus = showcaseContentModel.contentStatus == ContentStatusEnum.CONSUMED ? null : ContentStatusEnum.CONSUMED;
    notifyListeners();

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.contentStatus,
      rating: showcaseContentModel.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );
  }

  // TODO:
  Future favorite() async {
    showcaseContentModel.isFavorite = !showcaseContentModel.isFavorite;
    notifyListeners();

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.contentStatus,
      rating: showcaseContentModel.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );
  }

  // TODO:
  Future consumeLater() async {
    showcaseContentModel.isConsumeLater = !showcaseContentModel.isConsumeLater;
    notifyListeners();

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.contentStatus,
      rating: showcaseContentModel.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );
  }
}
