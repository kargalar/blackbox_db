import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_explore_button.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_logo.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_profile.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_search.dart';
import 'package:blackbox_db/6%20Provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      actions: [
        AppbarExploreButtons(),
        SizedBox(width: 10),
        AppbarProfile(),
        SizedBox(width: 10),
        if (loginUser.id < 0)
          InkWell(
            borderRadius: AppColors.borderRadiusAll,
            onTap: () {
              context.read<GeneralProvider>().managerPanel();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text("Manager Panel"),
            ),
          ),
      ],
    );
  }
}
