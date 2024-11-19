import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreContentList extends StatefulWidget {
  const ExploreContentList({
    super.key,
    required this.contentType,
  });

  final ContentTypeEnum contentType;

  @override
  State<ExploreContentList> createState() => _ExploreContentListState();
}

class _ExploreContentListState extends State<ExploreContentList> {
  List<ShowcaseContentModel> contentList = [];

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (contentList.isEmpty) {
      getShowcaseContent();
    }

    return isLoading
        ? const CupertinoActivityIndicator()
        : Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 0.5.sw,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 160,
                    mainAxisExtent: 260,
                  ),
                  shrinkWrap: true,
                  itemCount: contentList.length,
                  itemBuilder: (context, index) {
                    return ContentItem(
                      showcaseContentModel: ShowcaseContentModel(
                        contentId: contentList[index].contentId,
                        contentType: contentList[index].contentType,
                        isFavorite: contentList[index].isFavorite,
                        isConsumed: contentList[index].isConsumed,
                        rating: contentList[index].rating,
                        isReviewed: contentList[index].isReviewed,
                        isConsumeLater: contentList[index].isConsumeLater,
                      ),
                      showcaseType: ShowcaseTypeEnum.EXPLORE,
                    );
                  },
                ),
              ),
            ),
          );
  }

  void getShowcaseContent() async {
    try {
      contentList = await ServerManager().getExploreContent(
        contentType: widget.contentType,
        // TODO: userId
        userId: "1",
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
