import 'package:blackbox_db/2%20General/Widget/profile_picture.dart';
import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/3%20Page/Explore/explore_page.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_activity.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_home.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_lists.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_networks.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_reviews.dart';
import 'package:blackbox_db/3%20Page/Profile/Widget/profile_section.dart';
import 'package:blackbox_db/3%20Page/Profile/Widget/user_info.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/6%20Provider/general_provider.dart';
import 'package:blackbox_db/6%20Provider/profile_provider.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
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
  void dispose() {
    profileProvider.currentPageIndex = 0;

    super.dispose();
  }

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
                              await ServerManager().followUnfollow(
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
                          imageUrl: "https://images.pexels.com/photos/29191749/pexels-photo-29191749/free-photo-of-traditional-farmer-in-rural-vietnamese-setting.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
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
