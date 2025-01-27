import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReviewItem extends StatefulWidget {
  const ReviewItem({
    super.key,
    required this.reviewModel,
  });

  final ReviewModel reviewModel;

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfilePicture.review(
          imageUrl: widget.reviewModel.picturePath,
          userID: widget.reviewModel.userID,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.reviewModel.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                // if (widget.reviewModel.isFavorite)
                Icon(
                  Icons.favorite,
                  color: AppColors.red,
                  size: 15,
                ),
                RatingBarIndicator(
                  rating: 3,
                  itemSize: 17,
                  itemCount: 5,
                  unratedColor: AppColors.transparent,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppColors.main,
                  ),
                ),
              ],
            ),
            // TODO: 8 satırdan fazla ise  more butonu ile daha fazlası gösterilecek
            SizedBox(
              width: 0.36.sw,
              child: Text(
                widget.reviewModel.text,
                style: TextStyle(fontSize: 14),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 0.36.sw,
              child: Row(
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(width: 3),
                  Text(
                    50.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.comment,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(width: 3),
                  Text(
                    10.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('dd MMMM yyyy').format(widget.reviewModel.createdAt),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}
