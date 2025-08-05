import 'package:blackbox_db/2_General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileReviews extends StatefulWidget {
  const ProfileReviews({
    super.key,
    this.reviewList,
  });

  final List<UserReviewModel>? reviewList;

  @override
  State<ProfileReviews> createState() => _ProfileReviewsState();
}

class _ProfileReviewsState extends State<ProfileReviews> {
  bool isLoading = true;

  List<UserReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    if (widget.reviewList != null) {
      reviews = widget.reviewList!;
      isLoading = false;
    } else {
      getReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(height: 20),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.read<GeneralProvider>().content(
                            review.contentId,
                            review.contentType,
                          );
                    },
                    child: ContentPoster(
                      posterPath: review.posterPath,
                      contentType: review.contentType,
                      cacheSize: 700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        review.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      // if (review.isFavorite)
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
                    height: 150,
                    child: Text(
                      review.text,
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
                        SizedBox(width: 10),
                        Text(
                          DateFormat('dd MMMM yyyy').format(review.createdAt),
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
        });
  }

  void getReviews() async {
    reviews = await MigrationService().getUserReviews(
      userID: ProfileProvider().user!.id,
    );

    setState(() {
      isLoading = false;
    });
  }
}
