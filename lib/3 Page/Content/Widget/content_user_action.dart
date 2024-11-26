import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ContentUserAction extends StatelessWidget {
  const ContentUserAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final contentPageProvider = context.watch<ContentPageProvider>();

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppColors.borderRadiusAll,
          color: AppColors.panelBackground,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: RatingBar.builder(
                initialRating: contentPageProvider.contentModel!.rating,
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
            ),

            // actions
            Row(
              children: [
                // watch
                InkWell(
                  onTap: () {
                    contentPageProvider.consume();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: contentPageProvider.contentModel!.contentStatus == ContentStatusEnum.CONSUMED ? AppColors.main : null,
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
                      color: contentPageProvider.contentModel!.isFavorite ? AppColors.main : null,
                      size: 30,
                    ),
                  ),
                ),
                // wathlater
                InkWell(
                  onTap: () {
                    contentPageProvider.consumeLater();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.watch_later,
                      color: contentPageProvider.contentModel!.isConsumeLater ? AppColors.main : null,
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
                final log = ContentLogModel(
                  id: 0,
                  userID: 1,
                  date: DateTime.now(),
                  contentID: contentPageProvider.contentModel!.id,
                  contentType: contentPageProvider.contentModel!.contentType,
                  contentStatus: contentPageProvider.contentModel!.contentStatus,
                  rating: contentPageProvider.contentModel!.rating,
                  isFavorite: contentPageProvider.contentModel!.isFavorite,
                  contentTitle: contentPageProvider.contentModel!.title,
                  isConsumeLater: contentPageProvider.contentModel!.isConsumeLater,
                );
                // add log
                // open log dialog
                Get.dialog(
                  Dialog(
                    child:
                        // show log histroey
                        Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(log.contentTitle),
                              const SizedBox(width: 10),
                              Text("${log.contentStatus}"),
                              const SizedBox(width: 10),
                              Text("${log.rating}"),
                              const SizedBox(width: 10),
                              Text("${log.isFavorite}"),
                              const SizedBox(width: 10),
                              Text("${log.isConsumeLater}"),
                              const SizedBox(width: 10),
                              // edit
                              InkWell(
                                borderRadius: AppColors.borderRadiusAll,
                                onTap: () {
                                  // edit log
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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
      ),
    );
  }
}
