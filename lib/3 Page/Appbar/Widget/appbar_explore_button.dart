import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarExploreButtons extends StatelessWidget {
  const AppbarExploreButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      ExploreButton(contentType: ContentTypeEnum.MOVIE),
      ExploreButton(contentType: ContentTypeEnum.GAME),
      ExploreButton(contentType: ContentTypeEnum.BOOK),
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
    late final appbarProvider = context.read<GeneralProvider>();

    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        appbarProvider.explore(contentType);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(contentType == ContentTypeEnum.MOVIE
            ? "Movies"
            : contentType == ContentTypeEnum.GAME
                ? "Games"
                : "Books"),
      ),
    );
  }
}
