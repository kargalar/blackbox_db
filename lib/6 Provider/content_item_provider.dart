import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class ContentItemProvider with ChangeNotifier {
  ContentItemProvider({
    required this.showcaseContentModel,
  });

  ShowcaseContentModel showcaseContentModel;

  Future consume() async {
    showcaseContentModel.isConsumed = !showcaseContentModel.isConsumed;

    await ContentPageProvider().contentUserAction(
      contentId: showcaseContentModel.contentId,
      contentType: showcaseContentModel.contentType,
      contentStatus: showcaseContentModel.isConsumed ? ContentStatusEnum.CONSUMED : null,
      rating: showcaseContentModel.rating,
      isFavorite: showcaseContentModel.isFavorite,
      isConsumeLater: showcaseContentModel.isConsumeLater,
    );

    notifyListeners();
  }
}
