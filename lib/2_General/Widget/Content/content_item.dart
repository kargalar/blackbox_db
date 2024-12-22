import 'package:blackbox_db/2_General/Widget/Content/Widget/content_activity.dart';
import 'package:blackbox_db/2_General/Widget/Content/Widget/content_hover.dart';
import 'package:blackbox_db/2_General/Widget/Content/Widget/content_activity_bar.dart';
import 'package:blackbox_db/2_General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/2_General/Widget/Content/Widget/content_trend.dart';
import 'package:blackbox_db/6_Provider/content_item_provider.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/7_Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentItem extends StatefulWidget {
  const ContentItem({
    super.key,
    required this.showcaseContentModel,
    required this.showcaseType,
    this.isSearch = false,
    this.coverSize,
  });

  final ShowcaseContentModel showcaseContentModel;
  final ShowcaseTypeEnum showcaseType;
  final bool isSearch;
  final double? coverSize;

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContentItemProvider(showcaseContentModel: widget.showcaseContentModel),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) {
            if (widget.isSearch) return;

            setState(() {
              onHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              onHover = false;
            });
          },
          child: GestureDetector(
            onTap: () {
              context.read<GeneralProvider>().content(
                    widget.showcaseContentModel.contentId,
                    widget.showcaseContentModel.contentType,
                  );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: widget.coverSize,
                      child: ContentPoster(
                        posterPath: widget.showcaseContentModel.posterPath,
                        contentType: widget.showcaseContentModel.contentType,
                        cacheSize: 700,
                      ),
                    ),
                    if (!onHover && widget.showcaseType == ShowcaseTypeEnum.ACTIVITY) const ContentActivity(),
                    if (onHover) ContentHover(),
                    if (widget.showcaseType == ShowcaseTypeEnum.TREND) ContentTrend(),
                  ],
                ),
                if (widget.showcaseType == ShowcaseTypeEnum.EXPLORE) UserContentActivityBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
