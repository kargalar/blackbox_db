import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class ContentPoster extends StatelessWidget {
  const ContentPoster({
    super.key,
    required this.posterPath,
    this.size = 150,
  });

  final String? posterPath;
  final double size;

  const ContentPoster.showcase({
    Key? key,
    required String? posterPath,
  }) : this(
          key: key,
          posterPath: posterPath,
          size: 150,
        );

  const ContentPoster.contentPage({
    Key? key,
    required String? posterPath,
  }) : this(
          key: key,
          posterPath: posterPath,
          size: 200,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppColors.borderRadiusAll / 2,
        boxShadow: AppColors.bottomShadow,
      ),
      width: size,
      height: size * 1.5,
      child: ClipRRect(
        borderRadius: AppColors.borderRadiusAll / 2,
        child: posterPath != null
            ? Image.network(
                "https://image.tmdb.org/t/p/original$posterPath",
                fit: BoxFit.cover,
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
