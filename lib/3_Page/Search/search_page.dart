import 'package:blackbox_db/3_Page/Search/search_item.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/8_Model/search_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final generalProvider = context.read<GeneralProvider>();

  @override
  Widget build(BuildContext context) {
    return context.watch<GeneralProvider>().searchIsLoading
        ? const Center(child: CircularProgressIndicator())
        : generalProvider.searchContentList.isEmpty
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
                        itemCount: generalProvider.searchContentList.length,
                        itemBuilder: (context, index) {
                          return SearchItem(
                            searchMovieModel: SearchContentModel(
                              contentId: generalProvider.searchContentList[index].contentId,
                              contentPosterPath: generalProvider.searchContentList[index].contentPosterPath,
                              contentType: generalProvider.searchContentList[index].contentType,
                              isFavorite: generalProvider.searchContentList[index].isFavorite,
                              isConsumed: generalProvider.searchContentList[index].isConsumed,
                              rating: generalProvider.searchContentList[index].rating,
                              isReviewed: generalProvider.searchContentList[index].isReviewed,
                              isConsumeLater: generalProvider.searchContentList[index].isConsumeLater,
                              title: generalProvider.searchContentList[index].title,
                              description: generalProvider.searchContentList[index].description,
                              year: generalProvider.searchContentList[index].year,
                              originalTitle: generalProvider.searchContentList[index].originalTitle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
  }
}
