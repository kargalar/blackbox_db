import 'package:blackbox_db/3_Page/Content/content_page.dart';
import 'package:blackbox_db/3_Page/Explore/explore_page.dart';
import 'package:blackbox_db/3_Page/Appbar/main_appbar.dart';
import 'package:blackbox_db/3_Page/Home/home_page.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/manager_panel.dart';
import 'package:blackbox_db/3_Page/Profile/profile_page.dart';
import 'package:blackbox_db/3_Page/Search/search_page.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarManager extends StatefulWidget {
  const AppbarManager({super.key});

  @override
  State<AppbarManager> createState() => AppbarManagerState();
}

class AppbarManagerState extends State<AppbarManager> {
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ExploreContentPage(),
    ProfilePage(),
    ContentPage(),
    ManagerPanel(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppbar(),
      body: _pages[context.watch<GeneralProvider>().currentIndex],
    );
  }
}
