import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ContentList extends StatelessWidget {
  const ContentList({
    super.key,
    required this.rating,
    required this.isFavorite,
    required this.isReviewed,
  });

  final double? rating;
  final bool isFavorite;
  final bool isReviewed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
        width: 150,
        child: Row(
          children: [
            RatingBarIndicator(
              rating: rating ?? 0,
              itemSize: 15,
              itemCount: 5,
              unratedColor: AppColors.transparent,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: AppColors.main,
              ),
            ),
            const Spacer(),
            if (isFavorite)
              const Icon(
                Icons.favorite,
                color: AppColors.white,
                size: 15,
              ),
            const SizedBox(width: 5),
            if (isReviewed)
              const Icon(
                Icons.comment,
                color: AppColors.white,
                size: 15,
              ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
