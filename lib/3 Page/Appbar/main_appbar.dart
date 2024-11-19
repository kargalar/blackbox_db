import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_explore_button.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_logo.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_profile.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_search.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 170,
      leading: const AppbarLogo(),
      title: const AppbarSearch(),
      actions: const [
        AppbarExploreButtons(),
        SizedBox(width: 10),
        AppbarProfile(),
        SizedBox(width: 10),
      ],
    );
  }
}
