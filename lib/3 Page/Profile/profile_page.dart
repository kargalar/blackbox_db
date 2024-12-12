import 'package:blackbox_db/2%20General/Widget/profile_picture.dart';
import 'package:blackbox_db/3%20Page/Explore/explore_page.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_activity.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_home.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_lists.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_networks.dart';
import 'package:blackbox_db/3%20Page/Profile/Sections/profile_reviews.dart';
import 'package:blackbox_db/3%20Page/Profile/Widget/profile_section.dart';
import 'package:blackbox_db/3%20Page/Profile/Widget/user_info.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/6%20Provider/profile_provider.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
  void initState() {
    super.initState();
//TODO: içerikler ve loglar profile ait olacak ama hover kullanıcıya ait olacak
// generalProvider.currentUserID
  }

  @override
  void dispose() {
    profileProvider.currentPageIndex = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return exploreProvider.isLoadingPage
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // row profile picture - profile sections (home, movie, game, reviews, lists, network, activity)
                SizedBox(height: 100),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // profile picture
                    // TODO:
                    ProfileImage.profile(
                      imageUrl: "https://images.pexels.com/photos/29191749/pexels-photo-29191749/free-photo-of-traditional-farmer-in-rural-vietnamese-setting.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    ),
                    SizedBox(width: 10),
                    UserInfo(),
                    SizedBox(width: 80),

                    ProfileSections()
                  ],
                ),
                SizedBox(height: 30),

                // ExploreContentPage(isProfilePage: true),
                profilePages[profileProvider.currentPageIndex],
              ],
            ),
          );
  }
}
