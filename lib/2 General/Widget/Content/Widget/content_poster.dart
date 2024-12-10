import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContentPoster extends StatelessWidget {
  const ContentPoster({
    super.key,
    required this.posterPath,
    required this.contentType,
    this.cacheSize = 300,
  });

  final String? posterPath;
  final ContentTypeEnum contentType;
  final int cacheSize;

  @override
  Widget build(BuildContext context) {
    late String imageURL;

    if (contentType == ContentTypeEnum.MOVIE) {
      imageURL = "https://image.tmdb.org/t/p/original$posterPath";
    } else if (contentType == ContentTypeEnum.BOOK) {
      // imageURL =
    } else if (contentType == ContentTypeEnum.GAME) {
      imageURL = "https://images.igdb.com/igdb/image/upload/t_720p/$posterPath.jpg";
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppColors.borderRadiusAll / 2,
          boxShadow: AppColors.bottomShadow,
        ),
        child: ClipRRect(
          borderRadius: AppColors.borderRadiusAll / 2,
          child: posterPath != null
              ? CachedNetworkImage(
                  imageUrl: imageURL,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 150),
                  fadeOutDuration: const Duration(milliseconds: 150),
                  memCacheHeight: cacheSize,
                  placeholder: (context, url) {
                    // shimmer
                    return Shimmer.fromColors(
                      baseColor: AppColors.deepBlack,
                      highlightColor: AppColors.panelBackground,
                      period: const Duration(seconds: 2),
                      child: Container(
                        color: AppColors.transparantBlack,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.panelBackground,
                    child: const Center(
                      child: Text(
                        "Something",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              :
              // not found
              Container(
                  color: AppColors.panelBackground,
                  child: const Center(
                    child: Text(
                      "Not Found",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
