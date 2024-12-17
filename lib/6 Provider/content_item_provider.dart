import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class ContentItemProvider with ChangeNotifier {
  ContentItemProvider({
    required this.showcaseContentModel,
  });

  ShowcaseContentModel showcaseContentModel;

  // TODO:
  Future consume() async {
    showcaseContentModel.contentStatus = showcaseContentModel.contentStatus == ContentStatusEnum.CONSUMED ? null : ContentStatusEnum.CONSUMED;

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.contentStatus,
      rating: showcaseContentModel.contentLog?.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );

    notifyListeners();
  }

  // TODO:
  Future favorite() async {
    showcaseContentModel.isFavorite = !showcaseContentModel.isFavorite;

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.contentStatus,
      rating: showcaseContentModel.contentLog?.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );

    notifyListeners();
  }

  // TODO:
  Future consumeLater() async {
    showcaseContentModel.isConsumeLater = !showcaseContentModel.isConsumeLater;

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.contentStatus,
      rating: showcaseContentModel.contentLog?.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );

    notifyListeners();
  }
}
