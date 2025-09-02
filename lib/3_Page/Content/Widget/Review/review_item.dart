import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
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
          userId: widget.reviewModel.userId,
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
                if (widget.reviewModel.isFavorite)
                  Icon(
                    Icons.favorite,
                    color: AppColors.red,
                    size: 15,
                  ),
                if (widget.reviewModel.rating != null)
                  RatingBarIndicator(
                    rating: widget.reviewModel.rating!,
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
                  InkWell(
                    onTap: () async {
                      try {
                        // Get current user
                        final currentUser = await MigrationService().getCurrentUserProfile();
                        if (currentUser != null) {
                          // Toggle like in database
                          final isLiked = await MigrationService().toggleReviewLike(
                            reviewId: widget.reviewModel.id,
                            userId: currentUser.id,
                          );

                          // Get the actual like count from database to avoid sync issues
                          final actualLikeCount = await MigrationService().getReviewLikeCount(widget.reviewModel.id);

                          // Update UI with actual data
                          setState(() {
                            widget.reviewModel.isLikedByCurrentUser = isLiked;
                            widget.reviewModel.likeCount = actualLikeCount;
                          });
                        }
                      } catch (e) {
                        debugPrint('Error toggling like: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Beğeni işlemi başarısız oldu')),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          widget.reviewModel.isLikedByCurrentUser ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: widget.reviewModel.isLikedByCurrentUser ? AppColors.main : Colors.grey,
                          size: 16,
                        ),
                        SizedBox(width: 3),
                        Text(
                          widget.reviewModel.likeCount.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      // TODO: Add note/reply functionality instead of comments
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Not eklemek için tıklayın'),
                          action: SnackBarAction(
                            label: 'Not Ekle',
                            onPressed: () {
                              // Open note dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Not Ekle'),
                                  content: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Notunuzu yazın...',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('İptal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Not eklendi!')),
                                        );
                                      },
                                      child: Text('Kaydet'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_add,
                          color: Colors.grey,
                          size: 16,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Not Ekle',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
