import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_activity.dart';
import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_hover.dart';
import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_list.dart';
import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_poster.dart';
import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_trend.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentItem extends StatefulWidget {
  const ContentItem({
    super.key,
    required this.showcaseContentModel,
    required this.showcaseType,
  });

  final ShowcaseContentModel showcaseContentModel;
  final ShowcaseTypeEnum showcaseType;

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
        child: GestureDetector(
          onTap: () {
            context.read<PageProvider>().content(
                  widget.showcaseContentModel.contentId,
                  widget.showcaseContentModel.contentType,
                );
          },
          child: Column(
            children: [
              Stack(
                children: [
                  ContentPoster(
                    contentType: widget.showcaseContentModel.contentType,
                    posterPath: widget.showcaseContentModel.contentPosterPath,
                  ),
                  // TODO: activity için farklı model oluşturulduktan sonra devam edilecek. contentActivity yorum satırına alındı
                  if (!onHover && widget.showcaseType == ShowcaseTypeEnum.ACTIVITY) const ContentActivity(),
                  if (onHover)
                    ContentHover(
                      isFavori: widget.showcaseContentModel.isFavorite,
                      isConsumed: widget.showcaseContentModel.isConsumed,
                      isConsumeLater: widget.showcaseContentModel.isConsumeLater,
                    ),
                  if (widget.showcaseType == ShowcaseTypeEnum.TREND) const ContentTrend(),
                ],
              ),
              if (widget.showcaseType == ShowcaseTypeEnum.EXPLORE)
                ContentList(
                  // TODO: normalde burası giriş yapan kullanıcıya göre değil profili gezilen kullanıcını veya giriş yapan kullanıcıya göre olacak
                  rating: widget.showcaseContentModel.rating,
                  isFavorite: widget.showcaseContentModel.isFavorite,
                  isReviewed: widget.showcaseContentModel.isReviewed,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
