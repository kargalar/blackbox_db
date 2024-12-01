import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class ContentItemProvider with ChangeNotifier {
  ContentItemProvider({
    required this.showcaseContentModel,
  });

  ShowcaseContentModel showcaseContentModel;

  Future consume() async {
    await ContentPageProvider().consume(contentId: showcaseContentModel.contentId);

    showcaseContentModel.isConsumed = !showcaseContentModel.isConsumed;

    notifyListeners();
  }
}
