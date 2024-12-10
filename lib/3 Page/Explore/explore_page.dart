import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/explore_filter.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ExploreProvider exploreProvider = context.watch<ExploreProvider>();

  @override
  void initState() {
    super.initState();

    Provider.of<ExploreProvider>(context, listen: false).getContent();
  }

  @override
  Widget build(BuildContext context) {
    return exploreProvider.isLoadingPage
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 220),
                    exploreProvider.isLoadingContents
                        ? SizedBox(
                            width: 0.52.sw,
                            height: 0.8.sh,
                            child: Center(
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : ContentList(
                            contentList: exploreProvider.contentList,
                            showcaseType: ShowcaseTypeEnum.EXPLORE,
                          ),
                    SizedBox(width: 30),
                    ExploreFilter(),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ExploreProvider().currentPageIndex != 1)
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          ExploreProvider().currentPageIndex = 1;
                          ExploreProvider().getContent();
                        },
                        child: Text('${1}'),
                      ),
                    ...List.generate(
                      5,
                      (index) => TextButton(
                        onPressed: () {
                          ExploreProvider().currentPageIndex += index;
                          ExploreProvider().getContent();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: index == 0 ? AppColors.blue : null,
                        ),
                        child: Text('${ExploreProvider().currentPageIndex + index}'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ExploreProvider().currentPageIndex += 1;
                        ExploreProvider().getContent();
                      },
                      child: Text('${ExploreProvider().totalPageIndex}'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          );
  }
}
