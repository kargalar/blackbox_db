import 'package:blackbox_db/2_General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:flutter/material.dart';

class ProfileReviews extends StatefulWidget {
  const ProfileReviews({
    super.key,
  });

  @override
  State<ProfileReviews> createState() => _ProfileReviewsState();
}

class _ProfileReviewsState extends State<ProfileReviews> {
  bool isLoading = true;

  List<UserReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();

    getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Row(
              children: [
                SizedBox(
                  height: 200,
                  child: ContentPoster(
                    posterPath: review.posterPath,
                    contentType: ContentTypeEnum.MOVIE,
                    cacheSize: 700,
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                        Text(review.text),
                        SizedBox(height: 8),
                        Text(
                          'Reviewed on: ${review.createdAt.toLocal()}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void getReviews() async {
    reviews = await ServerManager().getUserReviews(userID: ProfileProvider().user!.id);

    setState(() {
      isLoading = false;
    });
  }
}
