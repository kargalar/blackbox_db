import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/explore_filter.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final appbarProvider = context.watch<PageProvider>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 220),
            ContentList(
              contentType: appbarProvider.exploreContentType,
              showcaseType: ShowcaseTypeEnum.EXPLORE,
              isExplorePage: true,
            ),
            ExploreFilter(),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (PageProvider().currentPageIndex != 1)
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  PageProvider().currentPageIndex = 1;
                },
                child: Text('${1}'),
              ),
            ...List.generate(
              5,
              (index) => TextButton(
                onPressed: () {
                  PageProvider().currentPageIndex += index;
                },
                style: TextButton.styleFrom(
                  backgroundColor: index == 0 ? AppColors.blue : null,
                ),
                child: Text('${PageProvider().currentPageIndex + index}'),
              ),
            ),
            TextButton(
              onPressed: () {
                PageProvider().currentPageIndex += 1;
              },
              child: Text('${PageProvider().totalPageIndex}'),
            ),
          ],
        )
      ],
    );
  }
}
