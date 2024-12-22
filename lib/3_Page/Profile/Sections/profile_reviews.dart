import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
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
    return Center(
      child: Text("data"),
    );

    // return SizedBox(
    //   width: 0.5.sw,
    //   height: 0.8.sh,
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return Row(
    //         children: [
    //           //
    //         ],
    //       );
    //     },
    //   ),
    // );
  }

  void getReviews() async {
    reviews = await ServerManager().getUserReviews(contentId: ProfileProvider().user!.id);

    setState(() {
      isLoading = false;
    });
  }
}
