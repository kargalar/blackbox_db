import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarExploreButtons extends StatelessWidget {
  const AppbarExploreButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      ExploreButton(contentType: ContentTypeEnum.MOVIE),
      ExploreButton(contentType: ContentTypeEnum.GAME),
      // ExploreButton(contentType: ContentTypeEnum.BOOK),
    ]);
  }
}

class ExploreButton extends StatelessWidget {
  const ExploreButton({
    super.key,
    required this.contentType,
  });

  final ContentTypeEnum contentType;

  @override
  Widget build(BuildContext context) {
    late final generalProvider = context.read<GeneralProvider>();

    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        generalProvider.explore(contentType, context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          contentType == ContentTypeEnum.MOVIE
              ? "Movies"
              : contentType == ContentTypeEnum.GAME
                  ? "Games"
                  : "Books",
        ),
      ),
    );
  }
}
