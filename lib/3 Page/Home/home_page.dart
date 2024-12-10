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
          const Text("activity MOVIE"),
          // TODO istekler contentlistte değil ilgili sayfada atıalcak.
          // const ContentList(
          //   contentType: ContentTypeEnum.MOVIE,
          //   showcaseType: ShowcaseTypeEnum.EXPLORE,
          // ),
          const Text("activity game"),
          // const ContentList(
          //   contentType: ContentTypeEnum.GAME,
          //   showcaseType: ShowcaseTypeEnum.EXPLORE,
          // ),
          // const Text("trend BOOK"),
          // const ContentList(
          //   contentType: ContentTypeEnum.BOOK,
          //   showcaseType: ShowcaseTypeEnum.TREND,
          // ),
          // const Text("continue GAME"),
          // const ContentList(
          //   contentType: ContentTypeEnum.GAME,
          //   showcaseType: ShowcaseTypeEnum.CONTIUNE,
          // ),
          // const Text("flat GAME"),
          // const ContentList(
          //   contentType: ContentTypeEnum.GAME,
          //   showcaseType: ShowcaseTypeEnum.FLAT,
          // ),
          // const Text("explore all"),
          // const ContentList(
          //   showcaseType: ShowcaseTypeEnum.EXPLORE,
          // ),
          // Divider(color: AppColors.text),
          // const TestItems(),
          // SizedBox(height: 100),
        ],
      ),
    );
  }
}
