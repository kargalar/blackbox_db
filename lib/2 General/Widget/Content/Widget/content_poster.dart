import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContentPoster extends StatelessWidget {
  const ContentPoster({
    super.key,
    required this.posterPath,
    this.size = 150,
    this.cacheSize = 300,
  });

  final String? posterPath;
  final double size;
  final int cacheSize;

  const ContentPoster.showcase({
    Key? key,
    required String? posterPath,
  }) : this(
          key: key,
          posterPath: posterPath,
          size: 150,
          cacheSize: 700,
        );

  const ContentPoster.contentPage({
    Key? key,
    required String? posterPath,
  }) : this(
          key: key,
          posterPath: posterPath,
          size: 230,
          cacheSize: 2000,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size * 1.5,
      width: size,
      decoration: BoxDecoration(
        borderRadius: AppColors.borderRadiusAll / 2,
        boxShadow: AppColors.bottomShadow,
      ),
      child: ClipRRect(
        borderRadius: AppColors.borderRadiusAll / 2,
        child: posterPath != null
            ? CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/original$posterPath",
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 50),
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
    );
  }
}
