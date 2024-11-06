import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item_button.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentHover extends StatelessWidget {
  const ContentHover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColors.black.withOpacity(0.4),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentItemButton(
                  icon: Icons.favorite,
                  onTap: () {
                    // TODO: add to favorite
                  },
                ),
                ContentItemButton(
                  icon: Icons.remove_red_eye,
                  onTap: () {
                    // TODO: add to watched
                  },
                ),
                ContentItemButton(
                  icon: Icons.watch_later,
                  onTap: () {
                    // TODO: add to watchlist
                  },
                ),
                ContentItemButton(
                  icon: Icons.library_add,
                  onTap: () {
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
