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

  late List<ShowcaseContentModel> contentList = [];

  @override
  void initState() {
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).getContent(context.read<GeneralProvider>().exploreContentType);
  }

  @override
  Widget build(BuildContext context) {
    return profileProvider.isLoadingPage
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Text("Profile :: ${generalProvider.currentUserID}"),
          );
  }
}
