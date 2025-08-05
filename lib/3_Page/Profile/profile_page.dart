import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/3_Page/Explore/explore_page.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_activity.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_home.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_lists.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_networks.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_reviews.dart';
import 'package:blackbox_db/3_Page/Profile/Widget/profile_section.dart';
import 'package:blackbox_db/3_Page/Profile/Widget/user_info.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final profileProvider = context.watch<ProfileProvider>();
  late final generalProvider = context.watch<GeneralProvider>();
  late final exploreProvider = context.watch<ExploreProvider>();

  late List<ShowcaseContentModel> contentList = [];

  // ProfilePages
  final dynamic profilePages = [
    ProfileHome(),
    ExploreContentPage(isProfilePage: true),
    ExploreContentPage(isProfilePage: true),
    ProfileReviews(),
    ProfileLists(),
    ProfileNetworks(),
    ProfileActivity(),
  ];

  @override
  Widget build(BuildContext context) {
    return context.watch<ProfileProvider>().isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : context.watch<ProfileProvider>().user == null
            ? Center(
                child: Text("User not found"),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (context.watch<ProfileProvider>().user!.id != loginUser!.id)
                          TextButton(
                            onPressed: () async {
                              await MigrationService().followUnfollow(
                                userId: loginUser!.id,
                                followingUserID: context.read<ProfileProvider>().user!.id,
                              );

                              setState(() {
                                context.read<ProfileProvider>().user!.isFollowed = !context.read<ProfileProvider>().user!.isFollowed!;
                              });
                            },
                            child: Text(
                              context.watch<ProfileProvider>().user!.isFollowed! ? "Unfollow" : "Follow",
                            ),
                          ),
                        SizedBox(width: 10),
                        // TODO:
                        ProfilePicture.profile(
                          imageUrl: context.read<ProfileProvider>().user!.picturePath,
                          userID: ProfileProvider().user!.id,
                        ),
                        SizedBox(width: 10),
                        UserInfo(
                          user: ProfileProvider().user!,
                        ),
                        SizedBox(width: 80),
                        ProfileSections()
                      ],
                    ),
                    SizedBox(height: 30),
                    profilePages[profileProvider.currentPageIndex],
                  ],
                ),
              );
  }
}
