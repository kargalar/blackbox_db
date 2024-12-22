import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/content_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentTrend extends StatelessWidget {
  const ContentTrend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final showcaseContentModel = context.read<ContentItemProvider>().showcaseContentModel;
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
        child: Text(
          "#${showcaseContentModel.trendIndex! + 1}",
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
