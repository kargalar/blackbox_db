import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSections extends StatelessWidget {
  const ProfileSections({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: AppColors.borderRadiusAll,
            color: AppColors.panelBackground,
          ),
          child: Row(
            children: [
              sectionItem(
                title: "Home",
                index: 0,
                onPressed: () {
                  context.read<ProfileProvider>().goHomePage(context);
                },
              ),
              sectionItem(
                title: "Movie",
                index: 1,
                onPressed: () {
                  context.read<ProfileProvider>().goMoviePage(context);
                },
              ),
              sectionItem(
                title: "Game",
                index: 2,
                onPressed: () {
                  context.read<ProfileProvider>().goGamePage(context);
                },
              ),
              sectionItem(
                title: "Reviews",
                index: 3,
                onPressed: () {
                  context.read<ProfileProvider>().goReviewPage(context);
                },
              ),
              sectionItem(
                title: "Lists",
                index: 4,
                onPressed: () {
                  context.read<ProfileProvider>().goListPage(context);
                },
              ),
              sectionItem(
                title: "Network",
                index: 5,
                onPressed: () {
                  context.read<ProfileProvider>().goNetworkPage(context);
                },
              ),
              sectionItem(
                title: "Activity",
                index: 6,
                onPressed: () {
                  context.read<ProfileProvider>().goActivityPage(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sectionItem({
    required String title,
    required void Function() onPressed,
    required int index,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        minimumSize: Size(50, 30),
        backgroundColor: ProfileProvider().currentPageIndex == index ? AppColors.main : AppColors.transparent,
      ),
      child: Text(title),
    );
  }
}
