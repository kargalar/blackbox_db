import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/select_filter.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/6%20Provider/general_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExploreFilter extends StatefulWidget {
  const ExploreFilter({
    super.key,
  });

  @override
  State<ExploreFilter> createState() => _ExploreFilterState();
}

class _ExploreFilterState extends State<ExploreFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 600,
      decoration: BoxDecoration(
        borderRadius: AppColors.borderRadiusAll,
        color: AppColors.panelBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 0.5,
                direction: Axis.horizontal,
                glow: false,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 35,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: AppColors.main,
                ),
                onRatingUpdate: (rating) {
                  // if (rating == userRating) return;

                  // userRating = rating;
                  // contentPageProvider.contentUserAction(
                  //   contentType: contentPageProvider.contentModel!.contentType,
                  //   contentStatus: ContentStatusEnum.CONSUMED,
                  //   rating: userRating,
                  //   isFavorite: contentPageProvider.contentModel!.isFavorite,
                  //   isConsumeLater: contentPageProvider.contentModel!.isConsumeLater,
                  // );
                },
              ),
            ),
            if (GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieGenres != null : ExploreProvider().allGameGenres != null)
              SelectFilter(
                title: "Genre",
                addItem: (item) {
                  ExploreProvider().genreFilteredList.add(item);
                  ExploreProvider().getContent(context: context);
                },
                removeItem: (item) {
                  ExploreProvider().genreFilteredList.remove(item);
                  ExploreProvider().getContent(context: context);
                },
                allItemList: GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieGenres! : ExploreProvider().allGameGenres!,
                filteredItemList: ExploreProvider().genreFilteredList,
              ),
            if (GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieLanguage != null : ExploreProvider().allGameLanguage != null)
              SelectFilter(
                title: "Language",
                addItem: (item) {
                  ExploreProvider().languageFilter = item;
                  ExploreProvider().getContent(context: context);
                },
                removeItem: (item) {
                  ExploreProvider().languageFilter = null;
                  ExploreProvider().getContent(context: context);
                },
                allItemList: GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieLanguage! : ExploreProvider().allGameLanguage!,
                selectedItem: ExploreProvider().languageFilter,
              ),
          ],
        ),
      ),
    );
  }
}
