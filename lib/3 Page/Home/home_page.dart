import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.EXPLORE,
          ),
          const ContentList(
            showcaseType: ShowcaseTypeEnum.EXPLORE,
          ),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.ACTIVITY,
          ),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.TREND,
          ),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.LIST,
          ),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.CONTIUNE,
          ),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.FLAT,
          ),

          // TEST TEST TEST TEST TEST TEST TEST TEST
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // activity
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
              // explore
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
              // continue
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
              // list
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
              // trend
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
              // flat
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
