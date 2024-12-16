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
        ? SizedBox(
            width: 0.4.sw,
            height: 150,
            child: Center(child: Text("Empty")),
          )
        : Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 0.4.sw,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  childAspectRatio: 0.64,
                ),
                shrinkWrap: true,
                itemCount: widget.contentList.length,
                itemBuilder: (context, index) {
                  return ContentItem(
                    showcaseContentModel: widget.contentList[index]..trendIndex = index,
                    showcaseType: widget.showcaseType,
                  );
                },
              ),
            ),
          );
  }
}
