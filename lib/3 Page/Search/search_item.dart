import 'package:blackbox_db/2%20General/Widget/Content/content_item.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/search_content_model.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.searchContentModel,
  });
  final SearchContentModel searchContentModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        context.read<PageProvider>().content(
              searchContentModel.contentId,
              searchContentModel.contentType,
            );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentItem(
            isSearch: true,
            showcaseContentModel: ShowcaseContentModel(
              contentId: searchContentModel.contentId,
              posterPath: searchContentModel.contentPosterPath,
              contentType: searchContentModel.contentType,
              isFavorite: searchContentModel.isFavorite,
              isConsumed: searchContentModel.isConsumed,
              isConsumeLater: searchContentModel.isConsumeLater,
              rating: searchContentModel.rating,
              isReviewed: searchContentModel.isReviewed,
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
                      searchContentModel.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      searchContentModel.year,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.text.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                if (searchContentModel.title != searchContentModel.originalTitle)
                  Text(
                    searchContentModel.originalTitle!,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                // TODO: director
                // Text(searchContentModel.creator),
                SizedBox(
                  width: 0.3.sw,
                  child: Text(
                    searchContentModel.description,
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
