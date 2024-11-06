import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_activity.dart';
import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_hover.dart';
import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_trend.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:flutter/material.dart';

class ContentItem extends StatefulWidget {
  const ContentItem({
    super.key,
    required this.contentType,
    required this.showcaseType,
    required this.coverURL,
  });

  final ContentTypeEnum contentType;
  final ShowcaseTypeEnum showcaseType;
  final String coverURL;

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            onHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            onHover = false;
          });
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: AppColors.borderRadiusAll / 2,
                    boxShadow: AppColors.bottomShadow,
                  ),
                  width: 150,
                  height: 220,
                  child: ClipRRect(
                    borderRadius: AppColors.borderRadiusAll / 2,
                    child: Image.network(
                      widget.coverURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (widget.showcaseType == ShowcaseTypeEnum.ACTIVITY) const ContentActivity(),
                if (onHover) const ContentHover(),
                if (widget.showcaseType == ShowcaseTypeEnum.TREND) const ContentTrend(),
              ],
            ),
            if (widget.showcaseType == ShowcaseTypeEnum.LIST)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      ...List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          size: 15,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.favorite,
                        color: AppColors.white,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.comment,
                        color: AppColors.white,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
