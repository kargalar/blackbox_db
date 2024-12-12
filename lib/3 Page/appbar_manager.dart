import 'package:blackbox_db/3%20Page/Content/content_page.dart';
import 'package:blackbox_db/3%20Page/Explore/explore_page.dart';
import 'package:blackbox_db/3%20Page/Appbar/main_appbar.dart';
import 'package:blackbox_db/3%20Page/Home/home_page.dart';
import 'package:blackbox_db/3%20Page/Profile/profile_page.dart';
import 'package:blackbox_db/3%20Page/Search/search_page.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarManager extends StatefulWidget {
  const AppbarManager({super.key});

  @override
  State<AppbarManager> createState() => AppbarManagerState();
}

class AppbarManagerState extends State<AppbarManager> {
  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    ExplorePage(),
    ProfilePage(),
    ContentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppbar(),
      body: _pages[context.watch<GeneralProvider>().currentIndex],
    );
  }
}
