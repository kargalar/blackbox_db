import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:flutter/material.dart';

class SelectFilter extends StatefulWidget {
  const SelectFilter({super.key});

  @override
  State<SelectFilter> createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  void _addItem(GenreModel item) {
    ExploreProvider().filteredGenreList.add(item);
    ExploreProvider().getContent();
  }

  void _removeItem(GenreModel item) {
    ExploreProvider().filteredGenreList.remove(item);
    ExploreProvider().getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genre Dropdown
        PopupMenuButton<GenreModel>(
          color: AppColors.panelBackground2,
          offset: const Offset(-95, 0),
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false, // Allows customization with custom widget
              child: StatefulBuilder(builder: (context, setStateMenu) {
                return SizedBox(
                  width: 300, // Adjust width
                  child: ExploreProvider().allGenres!.length == ExploreProvider().filteredGenreList.length
                      ? Center(
                          child: Text(
                            "Başka Seçenek Yok",
                            style: TextStyle(
                              color: AppColors.dirtyWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: ExploreProvider().allGenres!.length == ExploreProvider().filteredGenreList.length ? 2 : 2,
                          children: ExploreProvider().allGenres!.where((genre) => !ExploreProvider().filteredGenreList.contains(genre)).map((genre) {
                            return InkWell(
                              borderRadius: AppColors.borderRadiusAll,
                              onTap: () {
                                setState(() {
                                  setStateMenu(() {
                                    _addItem(genre);
                                  });
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.panelBackground,
                                  borderRadius: AppColors.borderRadiusAll,
                                ),
                                child: AutoSizeText(
                                  genre.name,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                );
              }),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Genre",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          children: ExploreProvider().filteredGenreList.map((genre) {
            return InkWell(
              onTap: () {
                _removeItem(genre);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.panelBackground2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      genre.name,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
