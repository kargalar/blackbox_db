import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContentPoster extends StatelessWidget {
  const ContentPoster({
    super.key,
    required this.posterPath,
    required this.contentType,
    this.cacheSize = 300,
    this.onTap,
    this.heroTag,
  });

  final String? posterPath;
  final ContentTypeEnum contentType;
  final int cacheSize;
  final VoidCallback? onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    late String imageURL;

    if (contentType == ContentTypeEnum.MOVIE) {
      imageURL = "https://image.tmdb.org/t/p/original$posterPath";
    } else if (contentType == ContentTypeEnum.BOOK) {
      // imageURL =
    } else if (contentType == ContentTypeEnum.GAME) {
      imageURL = "https://images.igdb.com/igdb/image/upload/t_original/$posterPath.jpg";
    }

    final imageWidget = posterPath != null
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
        : Container(
            color: AppColors.panelBackground,
            child: const Center(
              child: Text(
                "Not Found",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );

    Widget content = ClipRRect(
      borderRadius: AppColors.borderRadiusAll / 2,
      child: heroTag != null ? Hero(tag: heroTag!, child: imageWidget) : imageWidget,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      );
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppColors.borderRadiusAll / 2,
          boxShadow: AppColors.bottomShadow,
        ),
        child: content,
      ),
    );
  }
}
