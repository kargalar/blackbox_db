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
        child: posterPath != null
            ? Image.network(
                //TODO: cover backendden poster_path olacak hepsinde
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
