import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ContentUserAction extends StatelessWidget {
  const ContentUserAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final contentPageProvider = context.watch<ContentPageProvider>();

    double userRating = contentPageProvider.contentModel!.rating ?? 0;

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
                initialRating: contentPageProvider.contentModel!.rating ?? 0,
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
                  if (rating == userRating) return;

                  userRating = rating;
                  contentPageProvider.contentUserAction(
                    contentType: contentPageProvider.contentModel!.contentType,
                    contentStatus: ContentStatusEnum.CONSUMED,
                    rating: userRating,
                    isFavorite: contentPageProvider.contentModel!.isFavorite ?? false,
                    isConsumeLater: contentPageProvider.contentModel!.isConsumeLater ?? false,
                  );
                },
              ),
            ),

            // actions
            Row(
              children: [
                // watch
                InkWell(
                  onTap: () {
                    final nextStatus = contentPageProvider.contentModel!.contentStatus != null ? null : ContentStatusEnum.CONSUMED;
                    contentPageProvider.contentUserAction(
                      contentType: contentPageProvider.contentModel!.contentType,
                      contentStatus: nextStatus,
                      rating: contentPageProvider.contentModel!.rating,
                      isFavorite: contentPageProvider.contentModel!.isFavorite ?? false,
                      isConsumeLater: contentPageProvider.contentModel!.isConsumeLater ?? false,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: contentPageProvider.contentModel!.contentStatus == ContentStatusEnum.CONSUMED ? AppColors.deepGreen : null,
                      size: 30,
                    ),
                  ),
                ),

                // favori
                InkWell(
                  onTap: () {
                    final currentFavorite = contentPageProvider.contentModel!.isFavorite ?? false;
                    final nextFavorite = !currentFavorite;
                    contentPageProvider.contentUserAction(
                      contentType: contentPageProvider.contentModel!.contentType,
                      contentStatus: contentPageProvider.contentModel!.contentStatus,
                      rating: contentPageProvider.contentModel!.rating,
                      isFavorite: nextFavorite,
                      isConsumeLater: contentPageProvider.contentModel!.isConsumeLater ?? false,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.favorite,
                      color: (contentPageProvider.contentModel!.isFavorite ?? false) ? AppColors.dirtyRed : null,
                      size: 30,
                    ),
                  ),
                ),
                // watchlater
                InkWell(
                  onTap: () {
                    final currentConsumeLater = contentPageProvider.contentModel!.isConsumeLater ?? false;
                    final nextConsumeLater = !currentConsumeLater;
                    contentPageProvider.contentUserAction(
                      contentType: contentPageProvider.contentModel!.contentType,
                      contentStatus: contentPageProvider.contentModel!.contentStatus,
                      rating: contentPageProvider.contentModel!.rating,
                      isFavorite: contentPageProvider.contentModel!.isFavorite ?? false,
                      isConsumeLater: nextConsumeLater,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.watch_later,
                      color: (contentPageProvider.contentModel!.isConsumeLater ?? false) ? AppColors.main : null,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
            // add review
            InkWell(
              onTap: () async {
                String? review;

                await showDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController reviewController = TextEditingController();
                    String? errorMessage;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Add Review"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 0.4.sw,
                                  child: TextField(
                                    controller: reviewController,
                                    maxLines: 10,
                                    minLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText: "Review",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    ),
                                  ),
                                ),
                                if (errorMessage != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (reviewController.text.trim().isEmpty) {
                                      setState(() {
                                        errorMessage = "Review cannot be empty";
                                      });
                                    } else {
                                      Navigator.pop(context, "Review");
                                      review = reviewController.text;
                                    }
                                  },
                                  child: const Text("Send"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );

                if (review != null) {
                  contentPageProvider.contentUserAction(
                    contentType: contentPageProvider.contentModel!.contentType,
                    contentStatus: contentPageProvider.contentModel!.contentStatus,
                    rating: contentPageProvider.contentModel!.rating,
                    isFavorite: contentPageProvider.contentModel!.isFavorite ?? false,
                    isConsumeLater: contentPageProvider.contentModel!.isConsumeLater ?? false,
                    review: review,
                  );
                }
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
              onTap: () async {
                // TODO: get backend
                final log = ContentLogModel(
                  userId: loginUser!.id,
                  date: DateTime.now(),
                  contentID: contentPageProvider.contentModel!.id!,
                  contentType: contentPageProvider.contentModel!.contentType,
                  contentStatus: contentPageProvider.contentModel!.contentStatus,
                  rating: contentPageProvider.contentModel!.rating,
                  isFavorite: contentPageProvider.contentModel!.isFavorite,
                  isConsumeLater: contentPageProvider.contentModel!.isConsumeLater,
                );
                // add log
                // open log dialog
                await Get.dialog(
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
                              // TODO:
                              // Text(log.contentTitle!),
                              // const SizedBox(width: 10),
                              // Text("${log.contentStatus}"),
                              // const SizedBox(width: 10),
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
