import 'package:blackbox_db/3%20Page/Search/search_item.dart';
import 'package:blackbox_db/5%20Service/igdb_service.dart';
import 'package:blackbox_db/5%20Service/tmdb_service.dart';
import 'package:blackbox_db/6%20Provider/general_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/search_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final pageProvider = context.read<GeneralProvider>();

  bool isLoading = true;

  late List<SearchContentModel> contentList;

  @override
  void initState() {
    super.initState();

    search();
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
            : SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 0.4.sw,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: contentList.length,
                        itemBuilder: (context, index) {
                          return SearchItem(
                            searchMovieModel: SearchContentModel(
                              contentId: contentList[index].contentId,
                              contentPosterPath: contentList[index].contentPosterPath,
                              contentType: contentList[index].contentType,
                              isFavorite: contentList[index].isFavorite,
                              isConsumed: contentList[index].isConsumed,
                              rating: contentList[index].rating,
                              isReviewed: contentList[index].isReviewed,
                              isConsumeLater: contentList[index].isConsumeLater,
                              title: contentList[index].title,
                              description: contentList[index].description,
                              year: contentList[index].year,
                              originalTitle: contentList[index].originalTitle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
  }

  Future<void> search() async {
    try {
      if (pageProvider.searchFilter == ContentTypeEnum.MOVIE) {
        contentList = await TMDBService().search(pageProvider.searchText);
      } else if (pageProvider.searchFilter == ContentTypeEnum.GAME) {
        contentList = await IGDBService().search(pageProvider.searchText);
      } else {
        // contentList = bookapi;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
