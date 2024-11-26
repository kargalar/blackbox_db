import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class TestItems extends StatelessWidget {
  const TestItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // activity
        Column(
          children: [
            const Text("ACTIVITY"),
            ContentItem(
              showcaseContentModel: ShowcaseContentModel(
                contentId: 0,
                contentType: ContentTypeEnum.MOVIE,
                isFavorite: false,
                isConsumed: true,
                rating: null,
                isReviewed: false,
                isConsumeLater: false,
              ),
              showcaseType: ShowcaseTypeEnum.ACTIVITY,
            ),
          ],
        ),
        // explore
        Column(
          children: [
            const Text("EXPLORE"),
            ContentItem(
              showcaseContentModel: ShowcaseContentModel(
                contentId: 1,
                contentType: ContentTypeEnum.BOOK,
                isFavorite: true,
                isConsumed: true,
                rating: null,
                isReviewed: false,
                isConsumeLater: false,
              ),
              showcaseType: ShowcaseTypeEnum.EXPLORE,
            ),
          ],
        ),
        // continue
        Column(
          children: [
            const Text("CONTINUE"),
            ContentItem(
              showcaseContentModel: ShowcaseContentModel(
                contentId: 2,
                contentType: ContentTypeEnum.GAME,
                isFavorite: false,
                isConsumed: false,
                rating: null,
                isReviewed: false,
                isConsumeLater: true,
              ),
              showcaseType: ShowcaseTypeEnum.CONTIUNE,
            ),
          ],
        ),
      ],
    );
  }
}
