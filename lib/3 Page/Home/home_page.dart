import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3%20Page/Home/test_items.dart';
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
          const TestItems(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // list
              Column(
                children: [
                  const Text("LIST"),
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
                ],
              ),
              // trend
              Column(
                children: [
                  const Text("TREND"),
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
                ],
              ),
              // flat
              Column(
                children: [
                  const Text("FLAT"),
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
          Divider(
            color: AppColors.text,
          ),
          const Text("explore all"),
          const ContentList(
            showcaseType: ShowcaseTypeEnum.EXPLORE,
          ),
          const Text("activity book"),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.ACTIVITY,
          ),
          const Text("trend BOOK"),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.TREND,
          ),
          const Text("list BOOK"),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.LIST,
          ),
          const Text("continue BOOK"),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.CONTIUNE,
          ),
          const Text("flat BOOK"),
          const ContentList(
            contentType: ContentTypeEnum.BOOK,
            showcaseType: ShowcaseTypeEnum.FLAT,
          ),
        ],
      ),
    );
  }
}
