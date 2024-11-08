import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ContentUserAction extends StatelessWidget {
  const ContentUserAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final contentPageProvider = context.watch<ContentPageProvider>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppColors.borderRadiusAll,
        color: AppColors.panelBackground,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: contentPageProvider.contentModel.rating,
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
              contentPageProvider.rate(rating);
            },
          ),

          // actions
          Row(
            children: [
              // watch
              InkWell(
                onTap: () {
                  contentPageProvider.watch();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: contentPageProvider.contentModel.isWatch ? AppColors.main : null,
                    size: 30,
                  ),
                ),
              ),

              // favori
              InkWell(
                onTap: () {
                  contentPageProvider.favorite();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.favorite,
                    color: contentPageProvider.contentModel.isFavorite ? AppColors.main : null,
                    size: 30,
                  ),
                ),
              ),
              // wathlater
              InkWell(
                onTap: () {
                  contentPageProvider.watchLater();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.watch_later,
                    color: contentPageProvider.contentModel.isWatchLater ? AppColors.main : null,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          // add review
          InkWell(
            onTap: () {
              // add review
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.rate_review,
                    size: 30,
                  ),
                ),
                Text(
                  "Add Review",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // edit or add log
          InkWell(
            onTap: () {
              // add log
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
                Text(
                  "Edit or Add Log",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // add to list
          InkWell(
            onTap: () {
              // add to list
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.playlist_add,
                    size: 30,
                  ),
                ),
                Text(
                  "Add to List",
                  style: TextStyle(
                    fontSize: 20,
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
