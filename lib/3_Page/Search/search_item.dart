import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox_db/2_General/Widget/Content/content_item.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8_Model/search_content_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.searchMovieModel,
  });
  final SearchContentModel searchMovieModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        context.read<GeneralProvider>().content(
              searchMovieModel.contentId,
              searchMovieModel.contentType,
            );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentItem(
            isSearch: true,
            coverSize: 250,
            showcaseContentModel: ShowcaseContentModel(
              contentId: searchMovieModel.contentId,
              posterPath: searchMovieModel.contentPosterPath,
              contentType: searchMovieModel.contentType,
              isFavorite: searchMovieModel.isFavorite,
              contentStatus: searchMovieModel.isConsumed ? ContentStatusEnum.CONSUMED : null,
              isConsumeLater: searchMovieModel.isConsumeLater,
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
                    SizedBox(
                      width: 0.275.sw,
                      child: AutoSizeText(
                        searchMovieModel.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (searchMovieModel.year != null)
                      Text(
                        searchMovieModel.year!,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.text.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
                if (searchMovieModel.title != searchMovieModel.originalTitle)
                  Text(
                    searchMovieModel.originalTitle!,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text.withValues(alpha: 0.6),
                    ),
                  ),
                // TODO: director
                // Text(searchMovieModel.creator),
                if (searchMovieModel.description != null)
                  SizedBox(
                    width: 0.3.sw,
                    child: Text(
                      searchMovieModel.description!,
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
