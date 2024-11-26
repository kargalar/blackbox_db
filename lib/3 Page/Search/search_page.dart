import 'package:blackbox_db/2%20General/Widget/Content/content_item.dart';
import 'package:blackbox_db/5%20Service/tmdb_service.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final appbarProvider = context.watch<PageProvider>();

  bool isLoading = true;

  late List<ShowcaseContentModel> contentList;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : contentList.isEmpty
            ? const Center(
                child: Text(
                  'No content found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
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
                            contentPosterPath: contentList[index].contentPosterPath,
                            contentType: contentList[index].contentType,
                            isFavorite: contentList[index].isFavorite,
                            isConsumed: contentList[index].isConsumed,
                            rating: contentList[index].rating,
                            isReviewed: contentList[index].isReviewed,
                            isConsumeLater: contentList[index].isConsumeLater,
                            trendIndex: index,
                          ),
                          showcaseType: ShowcaseTypeEnum.FLAT,
                        );
                      },
                    ),
                  ),
                ),
              );
  }

  Future<void> getData() async {
    try {
      contentList = await TMDBService().search(context.read<PageProvider>().searchText);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
