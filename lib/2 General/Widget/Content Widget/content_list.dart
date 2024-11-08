import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentList extends StatelessWidget {
  const ContentList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
        width: 150,
        child: Row(
          children: [
            const SizedBox(width: 5),
            ...List.generate(
              5,
              (index) => const Icon(
                Icons.star,
                size: 15,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.favorite,
              color: AppColors.white,
              size: 15,
            ),
            const SizedBox(width: 5),
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
