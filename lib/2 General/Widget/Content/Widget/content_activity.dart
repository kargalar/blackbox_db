import 'package:blackbox_db/2%20General/Widget/profile_picture.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContentActivity extends StatelessWidget {
  const ContentActivity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final showcaseContentModel = context.read<ContentItemProvider>().showcaseContentModel;

    return Positioned(
      bottom: 0,
      child: Container(
        width: 150,
        color: AppColors.black.withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              if (showcaseContentModel.reviewText != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  child: Text(
                    showcaseContentModel.reviewText!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              Row(
                children: [
                  ProfilePicture.content(
                    // TODO:
                    // imageUrl: "asd/cover/${userLog.userID}",
                    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/220px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg",
                    userID: showcaseContentModel.userID!,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat.MMMd().format(showcaseContentModel.date!),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (showcaseContentModel.rating != null)
                    Row(
                      children: [
                        Text(
                          showcaseContentModel.rating.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.star,
                          color: AppColors.white,
                          size: 17,
                        ),
                      ],
                    ),
                  if (showcaseContentModel.rating == null && showcaseContentModel.isConsumed)
                    const Icon(
                      Icons.remove_red_eye,
                      color: AppColors.white,
                      size: 20,
                    ),
                  if (showcaseContentModel.isConsumeLater)
                    const Icon(
                      Icons.watch_later,
                      color: AppColors.white,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
