import 'package:blackbox_db/2%20General/Widget/Content/content_item.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';

class TestItems extends StatelessWidget {
  const TestItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TEST TEST TEST TEST
            // activity
            Column(
              children: [
                const Text("ACTIVITY"),
                ContentItem(
                  showcaseContentModel: ShowcaseContentModel(
                    contentId: 0,
                    posterPath: "https://image.tmdb.org/t/p/original/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
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
                    posterPath: "https://image.tmdb.org/t/p/original/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
                    contentType: ContentTypeEnum.BOOK,
                    isFavorite: true,
                    isConsumed: true,
                    rating: 3.5,
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
                    posterPath: "https://image.tmdb.org/t/p/original/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
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
            Column(
              children: [
                const Text("TREND"),
                ContentItem(
                  showcaseContentModel: ShowcaseContentModel(
                    contentId: 4,
                    posterPath: "https://image.tmdb.org/t/p/original/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
                    contentType: ContentTypeEnum.BOOK,
                    isFavorite: false,
                    isConsumed: false,
                    rating: null,
                    isReviewed: false,
                    isConsumeLater: true,
                    trendIndex: 0,
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
                    posterPath: "https://image.tmdb.org/t/p/original/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
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
      ],
    );
  }
}
