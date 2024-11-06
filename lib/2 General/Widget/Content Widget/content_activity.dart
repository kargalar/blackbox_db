import 'package:blackbox_db/2%20General/Widget/profile_picture.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentActivity extends StatelessWidget {
  const ContentActivity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO:
    // activity type logdan alınacak şimdilik böyle
    // bool isReview = true;
    // bool isWatch = true;
    // bool isRate = true;
    // bool isAddWatchlist = true;
    // bool isAddList;

    return Positioned(
      bottom: 0,
      child: Container(
        height: 50,
        width: 150,
        color: AppColors.black.withOpacity(0.4),
        child:
            // profile picture
            const ProfileImage.content(
          imageUrl: "https://images.pexels.com/photos/29191749/pexels-photo-29191749/free-photo-of-traditional-farmer-in-rural-vietnamese-setting.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        ),

        // date

        // if isRate rate

        // if isReview review

        // if isWatch watch

        // if isAddWatchlist add to watchlist

        // if isAddList add to list
      ),
    );
  }
}
