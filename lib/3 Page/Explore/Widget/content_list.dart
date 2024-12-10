import 'package:blackbox_db/2%20General/Widget/Content/content_item.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentList extends StatefulWidget {
  const ContentList({
    super.key,
    required this.contentList,
    required this.showcaseType,
  });

  final ShowcaseTypeEnum showcaseType;
  final List<ShowcaseContentModel> contentList;

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  @override
  Widget build(BuildContext context) {
    return widget.contentList.isEmpty
        ? const Center(child: Text("Empty"))
        : Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 0.45.sw,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.64,
                ),
                shrinkWrap: true,
                itemCount: widget.contentList.length,
                itemBuilder: (context, index) {
                  return ContentItem(
                    showcaseContentModel: ShowcaseContentModel(
                      contentId: widget.contentList[index].contentId,
                      posterPath: widget.contentList[index].posterPath,
                      contentType: widget.contentList[index].contentType,
                      isFavorite: widget.contentList[index].isFavorite,
                      isConsumed: widget.contentList[index].isConsumed,
                      rating: widget.contentList[index].rating,
                      isReviewed: widget.contentList[index].isReviewed,
                      isConsumeLater: widget.contentList[index].isConsumeLater,
                      trendIndex: index,
                    ),
                    showcaseType: widget.showcaseType,
                  );
                },
              ),
            ),
          );
  }
}
