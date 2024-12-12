import 'package:blackbox_db/3%20Page/Explore/explore_page.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // late final profileProvider = context.watch<ProfileProvider>();
  late final generalProvider = context.watch<GeneralProvider>();
  late final exploreProvider = context.watch<ExploreProvider>();

  late List<ShowcaseContentModel> contentList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return exploreProvider.isLoadingPage
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text("Profile :: ${generalProvider.currentUserID}"),
                ),
                ExploreContentPage(isProfilePage: true),
              ],
            ),
          );
  }
}
