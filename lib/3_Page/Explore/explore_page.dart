import 'package:blackbox_db/3_Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3_Page/Explore/Widget/explore_filter.dart';
import 'package:blackbox_db/3_Page/Explore/Widget/explore_pagination.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/7_Enum/explore_sort_enum.dart';
import 'package:blackbox_db/7_Enum/showcase_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ExploreContentPage extends StatefulWidget {
  const ExploreContentPage({super.key, this.isProfilePage = false});

  final bool isProfilePage;

  @override
  State<ExploreContentPage> createState() => _ExploreContentPageState();
}

class _ExploreContentPageState extends State<ExploreContentPage> {
  @override
  Widget build(BuildContext context) {
    return context.watch<ExploreProvider>().isLoadingPage
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sort row
                        SizedBox(
                          width: 0.52.sw,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Explore', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              DropdownButton<ExploreSortEnum>(
                                value: context.watch<ExploreProvider>().sort,
                                underline: SizedBox.shrink(),
                                onChanged: (val) {
                                  if (val == null) return;
                                  final provider = context.read<ExploreProvider>();
                                  provider.sort = val;
                                  provider.getContent(context: context);
                                },
                                items: ExploreSortEnum.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.label),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        context.watch<ExploreProvider>().isLoadingContents
                            ? SizedBox(
                                width: 0.52.sw,
                                height: 0.8.sh,
                                child: Center(
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : ContentList(
                                contentList: context.watch<ExploreProvider>().contentList,
                                showcaseType: ShowcaseTypeEnum.EXPLORE,
                              ),
                      ],
                    ),
                    SizedBox(width: 30),
                    ExploreFilter(),
                  ],
                ),
                ExplorePagination(),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          );
  }
}
