import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/movie_page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/8%20Model/movie_log_model.dart';
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
    late final moviePageProvider = context.watch<MoviePageProvider>();

    double userRating = moviePageProvider.movieModel!.rating ?? 0;

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
                initialRating: moviePageProvider.movieModel!.rating ?? 0,
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
                  moviePageProvider.movieUserAction(
                    contentType: moviePageProvider.movieModel!.contentType,
                    contentStatus: ContentStatusEnum.CONSUMED,
                    rating: userRating,
                    isFavorite: moviePageProvider.movieModel!.isFavorite,
                    isConsumeLater: moviePageProvider.movieModel!.isConsumeLater,
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
                    moviePageProvider.movieModel!.contentStatus = moviePageProvider.movieModel!.contentStatus != null ? null : ContentStatusEnum.CONSUMED;

                    moviePageProvider.movieUserAction(
                      contentType: moviePageProvider.movieModel!.contentType,
                      contentStatus: moviePageProvider.movieModel!.contentStatus,
                      rating: moviePageProvider.movieModel!.rating,
                      isFavorite: moviePageProvider.movieModel!.isFavorite,
                      isConsumeLater: moviePageProvider.movieModel!.isConsumeLater,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: moviePageProvider.movieModel!.contentStatus == ContentStatusEnum.CONSUMED ? AppColors.deepGreen : null,
                      size: 30,
                    ),
                  ),
                ),

                // favori
                InkWell(
                  onTap: () {
                    moviePageProvider.movieModel!.isFavorite = !moviePageProvider.movieModel!.isFavorite;

                    moviePageProvider.movieUserAction(
                      contentType: moviePageProvider.movieModel!.contentType,
                      contentStatus: moviePageProvider.movieModel!.contentStatus,
                      rating: moviePageProvider.movieModel!.rating,
                      isFavorite: moviePageProvider.movieModel!.isFavorite,
                      isConsumeLater: moviePageProvider.movieModel!.isConsumeLater,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.favorite,
                      color: moviePageProvider.movieModel!.isFavorite ? AppColors.dirtyRed : null,
                      size: 30,
                    ),
                  ),
                ),
                // wathlater
                InkWell(
                  onTap: () {
                    moviePageProvider.movieModel!.isConsumeLater = !moviePageProvider.movieModel!.isConsumeLater;

                    moviePageProvider.movieUserAction(
                      contentType: moviePageProvider.movieModel!.contentType,
                      contentStatus: moviePageProvider.movieModel!.contentStatus,
                      rating: moviePageProvider.movieModel!.rating,
                      isFavorite: moviePageProvider.movieModel!.isFavorite,
                      isConsumeLater: moviePageProvider.movieModel!.isConsumeLater,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.watch_later,
                      color: moviePageProvider.movieModel!.isConsumeLater ? AppColors.main : null,
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
                final log = MovieLogModel(
                  id: 0,
                  userID: userID,
                  date: DateTime.now(),
                  movieID: moviePageProvider.movieModel!.id,
                  contentType: moviePageProvider.movieModel!.contentType,
                  contentStatus: moviePageProvider.movieModel!.contentStatus,
                  rating: moviePageProvider.movieModel!.rating,
                  isFavorite: moviePageProvider.movieModel!.isFavorite,
                  movieTitle: moviePageProvider.movieModel!.title,
                  isConsumeLater: moviePageProvider.movieModel!.isConsumeLater,
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
                              Text(log.movieTitle!),
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
