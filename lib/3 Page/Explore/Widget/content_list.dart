import 'package:blackbox_db/2%20General/Widget/Content/content_item.dart';
import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentList extends StatefulWidget {
  const ContentList({
    super.key,
    this.contentType,
    required this.showcaseType,
  });

  final ContentTypeEnum? contentType;
  final ShowcaseTypeEnum showcaseType;

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  List<ShowcaseContentModel>? contentList;

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (contentList == null) {
      getShowcaseContent();
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : contentList!.isEmpty
            ? const Center(child: Text("Empty"))
            : Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 0.5.sw,
                    child: GridView.builder(
                      // TODO: ekranın boyutuna göre öğeler esniyor. sabit kalmasını istiyorum.
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 160,
                        childAspectRatio: 0.6,
                      ),
                      shrinkWrap: true,
                      itemCount: contentList!.length,
                      itemBuilder: (context, index) {
                        return ContentItem(
                          showcaseContentModel: ShowcaseContentModel(
                            contentId: contentList![index].contentId,
                            posterPath: contentList![index].posterPath,
                            contentType: contentList![index].contentType,
                            isFavorite: contentList![index].isFavorite,
                            isConsumed: contentList![index].isConsumed,
                            rating: contentList![index].rating,
                            isReviewed: contentList![index].isReviewed,
                            isConsumeLater: contentList![index].isConsumeLater,
                            trendIndex: index,
                          ),
                          showcaseType: widget.showcaseType,
                        );
                      },
                    ),
                  ),
                ),
              );
  }

  void getShowcaseContent() async {
    try {
      // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
      // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
      // TODO: contentType null ise farklı istek atacak

      contentList = await ServerManager().getExploreMovie(
        contentType: widget.contentType,
        userId: userID,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
