import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/explore_filter.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/explore_pagination.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
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
  void initState() {
    super.initState();

    getContents();
  }

  void getContents() {
    Provider.of<ExploreProvider>(context, listen: false).isProfilePage = widget.isProfilePage;

    Provider.of<ExploreProvider>(context, listen: false).getContent(context);
  }

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
