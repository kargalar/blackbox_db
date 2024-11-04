import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/hover_menu_item.dart';
import 'package:flutter/material.dart';

class ProfileHoverMenu extends StatelessWidget {
  const ProfileHoverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppColors.borderRadiusBottom,
      child: Material(
        color: AppColors.panelBackground,
        child: const SizedBox(
          width: 160,
          child: Column(
            children: [
              HoverMenuItem(),
              HoverMenuItem(),
              HoverMenuItem(),
            ],
          ),
        ),
      ),
    );
  }
}
