import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/6%20Provider/general_provider.dart';
import 'package:blackbox_db/8%20Model/user_review_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ListView.builder(
      itemBuilder: (context, index) {
        return Row(
          children: [
            //
          ],
        );
      },
    );
  }

  void getReviews() async {
    reviews = await ServerManager().getUserReviews(contentId: context.read<GeneralProvider>().currentUserID);

    setState(() {
      isLoading = false;
    });
  }
}
