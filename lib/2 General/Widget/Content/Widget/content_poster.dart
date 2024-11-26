import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';

class ContentPoster extends StatelessWidget {
  const ContentPoster({
    super.key,
    required this.contentType,
    required this.posterPath,
  });

  final ContentTypeEnum contentType;
  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppColors.borderRadiusAll / 2,
        boxShadow: AppColors.bottomShadow,
      ),
      width: 150,
      height: 220,
      child: ClipRRect(
        borderRadius: AppColors.borderRadiusAll / 2,
        child: Image.network(
          //TODO: cover backendden poster_path olacak hepsinde
          contentType == ContentTypeEnum.MOVIE
              // ? "https://image.tmdb.org/t/p/original$posterPath"
              ? "https://image.tmdb.org/t/p/original/vNrbrsHOpXS3whk9DLuBNcjJy1s.jpg"
              : contentType == ContentTypeEnum.BOOK
                  ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCqYZBEzzpdbFogx5zqxp_cOtdRQw5oL3lyg&s"
                  : "https://images.igdb.com/igdb/image/upload/t_cover_big/co5xex.jpg",

          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
