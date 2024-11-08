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
                  id: 0,
                  contentType: ContentTypeEnum.MOVIE,
                  showcaseType: ShowcaseTypeEnum.ACTIVITY,
                  isFavori: false,
                  isWatched: true,
                  isWatchlist: false,
                ),
              ),
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  id: 1,
                  contentType: ContentTypeEnum.BOOK,
                  showcaseType: ShowcaseTypeEnum.EXPLORE,
                  isFavori: true,
                  isWatched: true,
                  isWatchlist: false,
                ),
              ),
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  id: 2,
                  contentType: ContentTypeEnum.GAME,
                  showcaseType: ShowcaseTypeEnum.CONTIUNE,
                  isFavori: false,
                  isWatched: false,
                  isWatchlist: true,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  id: 3,
                  contentType: ContentTypeEnum.MOVIE,
                  showcaseType: ShowcaseTypeEnum.LIST,
                  isFavori: false,
                  isWatched: false,
                  isWatchlist: false,
                ),
              ),
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  id: 4,
                  contentType: ContentTypeEnum.BOOK,
                  showcaseType: ShowcaseTypeEnum.TREND,
                  isFavori: false,
                  isWatched: false,
                  isWatchlist: true,
                ),
              ),
              ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  id: 5,
                  contentType: ContentTypeEnum.GAME,
                  showcaseType: ShowcaseTypeEnum.FLAT,
                  isFavori: false,
                  isWatched: false,
                  isWatchlist: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
