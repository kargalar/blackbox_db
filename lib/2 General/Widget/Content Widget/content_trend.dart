import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentTrend extends StatelessWidget {
  const ContentTrend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      left: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.8),
          borderRadius: AppColors.borderRadiusAll / 2,
        ),
        child: const Text(
          "#1",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
