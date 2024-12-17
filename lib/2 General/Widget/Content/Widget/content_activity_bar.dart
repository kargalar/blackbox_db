import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class UserContentActivityBar extends StatelessWidget {
  const UserContentActivityBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final showcaseContentModel = context.read<ContentItemProvider>().showcaseContentModel;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
        width: 150,
        child: Row(
          children: [
            // TODO: en son backendden user content alırken log gelmiyordu log gelince düzelecek
            if (showcaseContentModel.contentLog?.rating != null)
              RatingBarIndicator(
                rating: showcaseContentModel.contentLog!.rating!,
                itemSize: 15,
                itemCount: 5,
                unratedColor: AppColors.transparent,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: AppColors.main,
                ),
              ),
            const Spacer(),
            // TODO: burası da logdan gelecek
            if (showcaseContentModel.isFavorite)
              const Icon(
                Icons.favorite,
                color: AppColors.white,
                size: 15,
              ),
            const SizedBox(width: 5),
            if (showcaseContentModel.contentLog?.review != null)
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
