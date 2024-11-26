import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3%20Page/Home/test_items.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
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
