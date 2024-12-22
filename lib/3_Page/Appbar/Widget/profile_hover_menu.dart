import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/3_Page/Appbar/Widget/hover_menu_item.dart';
import 'package:blackbox_db/3_Page/Login/login_page.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHoverMenu extends StatelessWidget {
  const ProfileHoverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppColors.borderRadiusBottom,
      child: Material(
        color: AppColors.panelBackground,
        child: SizedBox(
          width: 160,
          child: Column(
            children: [
              HoverMenuFilterItem(contentType: ContentTypeEnum.MOVIE),
              HoverMenuFilterItem(contentType: ContentTypeEnum.GAME),
              // HoverMenuFilterItem(contentType: ContentTypeEnum.BOOK),
              // çıkış yap
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  // SharedPreferences
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('email');
                  prefs.remove('password');
                  Get.offUntil(
                    GetPageRoute(
                      page: () => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.red,
                ),
                child: const Text("Exit"),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
