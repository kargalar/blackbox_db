import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentItemButton extends StatelessWidget {
  const ContentItemButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.icon,
  });

  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          color: color,
          icon,
        ),
      ),
    );
  }
}
