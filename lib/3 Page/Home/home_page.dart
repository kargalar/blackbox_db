import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  contentId: 3,
                  contentType: ContentTypeEnum.MOVIE,
                  isFavorite: false,
                  isConsumed: false,
                  rating: null,
                  isReviewed: false,
                  isConsumeLater: false,
                ),
                showcaseType: ShowcaseTypeEnum.LIST,
              ),
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  contentId: 4,
                  contentType: ContentTypeEnum.BOOK,
                  isFavorite: false,
                  isConsumed: false,
                  rating: null,
                  isReviewed: false,
                  isConsumeLater: true,
                ),
                showcaseType: ShowcaseTypeEnum.TREND,
              ),
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  contentId: 5,
                  contentType: ContentTypeEnum.GAME,
                  isFavorite: false,
                  isConsumed: false,
                  rating: null,
                  isReviewed: false,
                  isConsumeLater: false,
                ),
                showcaseType: ShowcaseTypeEnum.FLAT,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
