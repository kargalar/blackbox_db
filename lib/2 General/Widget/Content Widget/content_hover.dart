import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item_button.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentHover extends StatelessWidget {
  const ContentHover({
    super.key,
    required this.isFavori,
    required this.isWatched,
    required this.isWatchlist,
  });

  final bool isFavori;
  final bool isWatched;
  final bool isWatchlist;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColors.black.withOpacity(0.3),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentItemButton(
                  icon: Icons.favorite,
                  color: isFavori ? AppColors.red : AppColors.white,
                  onTap: () {
                    // TODO: add to favorite
                  },
                ),
                ContentItemButton(
                  icon: Icons.remove_red_eye,
                  color: isWatched ? AppColors.red : AppColors.white,
                  onTap: () {
                    // TODO: add to watched
                  },
                ),
                ContentItemButton(
                  icon: Icons.watch_later,
                  color: isWatchlist ? AppColors.red : AppColors.white,
                  onTap: () {
                    // TODO: add to watchlist
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
