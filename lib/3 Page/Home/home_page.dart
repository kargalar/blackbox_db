import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
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
    return const Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContentItem(
                contentType: ContentTypeEnum.MOVIE,
                showcaseType: ShowcaseTypeEnum.ACTIVITY,
                coverURL: "https://assets.mubicdn.net/images/notebook/post_images/22267/images-w1400.jpg?1474980339",
              ),
              ContentItem(
                contentType: ContentTypeEnum.BOOK,
                showcaseType: ShowcaseTypeEnum.CONTIUNE,
                coverURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCqYZBEzzpdbFogx5zqxp_cOtdRQw5oL3lyg&s",
              ),
              ContentItem(
                contentType: ContentTypeEnum.GAME,
                showcaseType: ShowcaseTypeEnum.EXPLORE,
                coverURL: "https://images.igdb.com/igdb/image/upload/t_cover_big/co5xex.jpg",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContentItem(
                contentType: ContentTypeEnum.MOVIE,
                showcaseType: ShowcaseTypeEnum.LIST,
                coverURL: "https://assets.mubicdn.net/images/notebook/post_images/22267/images-w1400.jpg?1474980339",
              ),
              ContentItem(
                contentType: ContentTypeEnum.BOOK,
                showcaseType: ShowcaseTypeEnum.TREND,
                coverURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCqYZBEzzpdbFogx5zqxp_cOtdRQw5oL3lyg&s",
              ),
              ContentItem(
                contentType: ContentTypeEnum.GAME,
                showcaseType: ShowcaseTypeEnum.FLAT,
                coverURL: "https://images.igdb.com/igdb/image/upload/t_cover_big/co5xex.jpg",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
