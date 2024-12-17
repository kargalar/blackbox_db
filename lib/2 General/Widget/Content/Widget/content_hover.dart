import 'package:blackbox_db/2%20General/Widget/Content/Widget/content_item_button.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_item_provider.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentHover extends StatelessWidget {
  const ContentHover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColors.black.withOpacity(0.3),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentItemButton(
                  icon: Icons.remove_red_eye,
                  color: context.watch<ContentItemProvider>().showcaseContentModel.contentStatus == ContentStatusEnum.CONSUMED ? AppColors.green : AppColors.white,
                  onTap: () async {
                    await context.read<ContentItemProvider>().consume();
                  },
                ),
                ContentItemButton(
                  icon: Icons.favorite,
                  color: context.watch<ContentItemProvider>().showcaseContentModel.isFavorite ? AppColors.red : AppColors.white,
                  onTap: () async {
                    await context.read<ContentItemProvider>().favorite();
                  },
                ),
                ContentItemButton(
                  icon: Icons.watch_later,
                  color: context.watch<ContentItemProvider>().showcaseContentModel.isConsumeLater ? AppColors.main : AppColors.white,
                  onTap: () async {
                    await context.read<ContentItemProvider>().consumeLater();
                  },
                ),
                ContentItemButton(
                  icon: Icons.library_add,
                  // eğer herhangi bir listeye eklenmiş ise
                  //  color: isAddedList ? AppColors.red : AppColors.white,
                  color: AppColors.text,
                  onTap: () {
                    // tıklayınca ekleyebileceği listeler gelecek.
                    // TODO: add to library
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
