import 'package:blackbox_db/2%20General/Widget/Content/movie_item.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/search_movie_model.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.searchMovieModel,
  });
  final SearchMovieModel searchMovieModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        context.read<PageProvider>().content(
              searchMovieModel.movieId,
              searchMovieModel.contentType,
            );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieItem(
            isSearch: true,
            showcaseContentModel: ShowcaseMovieModel(
              movieId: searchMovieModel.movieId,
              posterPath: searchMovieModel.moviePosterPath,
              contentType: searchMovieModel.contentType,
              isFavorite: searchMovieModel.isFavorite,
              isConsumed: searchMovieModel.isConsumed,
              isConsumeLater: searchMovieModel.isConsumeLater,
              rating: searchMovieModel.rating,
              isReviewed: searchMovieModel.isReviewed,
            ),
            showcaseType: ShowcaseTypeEnum.FLAT,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      searchMovieModel.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      searchMovieModel.year,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.text.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                if (searchMovieModel.title != searchMovieModel.originalTitle)
                  Text(
                    searchMovieModel.originalTitle!,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                // TODO: director
                // Text(searchMovieModel.creator),
                SizedBox(
                  width: 0.3.sw,
                  child: Text(
                    searchMovieModel.description,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
