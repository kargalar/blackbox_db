import 'package:blackbox_db/2%20General/Widget/Content%20Widget/content_item.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreContentList extends StatelessWidget {
  const ExploreContentList({
    super.key,
    required this.contentType,
  });

  final ContentTypeEnum contentType;

  @override
  Widget build(BuildContext context) {
    return Center(
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
            itemCount: 20,
            itemBuilder: (context, index) {
              return ContentItem(
                showcaseContentModel: ShowcaseContentModel(
                  id: index,
                  contentType: contentType,
                  showcaseType: ShowcaseTypeEnum.EXPLORE,
                  isFavori: false,
                  isWatched: false,
                  isWatchlist: false,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
