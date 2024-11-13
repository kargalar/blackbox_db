import 'package:blackbox_db/2%20General/Widget/profile_picture.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ContentActivity extends StatelessWidget {
  const ContentActivity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ContentLogModel userLog = ContentLogModel(
      id: 1,
      date: DateTime.now(),
      contentID: 1,
      contentTitle: "Hit the Road ",
      contentCoverPath: "https://image.tmdb.org/t/p/original/s2VAydm53Odgafoto5NPLUeQgkX.jpg",
      contentType: ContentTypeEnum.MOVIE,
      contentStatus: ContentStatusEnum.CONSUMED,
      rating: 3.5,
      isFavorite: false,
      isConsumeLater: false,
      review: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps",
    );

    return Positioned(
      bottom: 0,
      child: Container(
        width: 150,
        color: AppColors.black.withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              // if isReview review
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 4,
                ),
                child: Text(
                  userLog.review!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              Row(
                children: [
                  // profile picture
                  ProfileImage.content(
                    imageUrl: userLog.contentCoverPath,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  // date
                  Text(
                    // "13 Oct",
// date show like "24 Oct"
                    DateFormat.MMMd().format(userLog.date),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // if isRate
                  if (userLog.rating != null)
                    Row(
                      children: [
                        Text(
                          userLog.rating.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.star,
                          color: AppColors.white,
                          size: 17,
                        ),
                      ],
                    ),

                  // if isWatch watch (if notRated)
                  if (userLog.rating == null && userLog.contentStatus == ContentStatusEnum.CONSUMED)
                    const Icon(
                      Icons.remove_red_eye,
                      color: AppColors.white,
                      size: 20,
                    ),

                  // if isAddWatchlist add to watchlist
                  if (userLog.isConsumeLater)
                    const Icon(
                      Icons.watch_later,
                      color: AppColors.white,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
