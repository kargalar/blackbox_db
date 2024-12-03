import 'package:blackbox_db/3%20Page/Search/search_item.dart';
import 'package:blackbox_db/5%20Service/tmdb_service.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
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
  late final appbarProvider = context.watch<PageProvider>();

  bool isLoading = true;

  late List<SearchMovieModel> contentList;

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
            : Align(
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
                          searchMovieModel: SearchMovieModel(
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
              );
  }

  Future<void> search() async {
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
