import 'package:blackbox_db/3%20Page/Explore/explore_page.dart';
import 'package:blackbox_db/3%20Page/Appbar/main_appbar.dart';
import 'package:blackbox_db/3%20Page/Home/home_page.dart';
import 'package:blackbox_db/3%20Page/Profile/profile_page.dart';
import 'package:blackbox_db/3%20Page/Search/search_page.dart';
import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
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
    // TODO: buraya 3 tane koymak yerine bir tane koyup yönlendirirken yapılandırmayı dene
    ExplorePage(contentType: ContentTypeEnum.MOVIE),
    ExplorePage(contentType: ContentTypeEnum.GAME),
    ExplorePage(contentType: ContentTypeEnum.BOOK),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppbar(),
      body: _pages[context.watch<AppbarProvider>().currentIndex],
    );
  }
}
