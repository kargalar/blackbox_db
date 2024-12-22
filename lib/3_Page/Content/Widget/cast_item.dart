import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/8_Model/cast_model.dart';
import 'package:flutter/material.dart';

class CastItem extends StatelessWidget {
  const CastItem({super.key, required this.crewModel});

  final CastModel crewModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        // kişinin sayfasına git
      },
      child: Container(
        width: 120,
        color: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO:
            // Container(
            //   color: AppColors.transparent,
            //   padding: const EdgeInsets.all(2),
            //   child: ClipRRect(
            //     borderRadius: AppColors.borderRadiusAll,
            //     child: Image.network(
            //       "https://image.tmdb.org/t/p/w200${crewModel.profilePath}",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Text(
              crewModel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
