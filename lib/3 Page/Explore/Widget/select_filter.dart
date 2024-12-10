import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:flutter/material.dart';

class SelectFilter extends StatefulWidget {
  const SelectFilter({super.key});

  @override
  State<SelectFilter> createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  void _addItem(GenreModel item) {
    if (!PageProvider().filteredGenreList.contains(item)) {
      setState(() {
        PageProvider().filteredGenreList.add(item);
      });
    }
  }

  void _removeItem(GenreModel item) {
    setState(() {
      PageProvider().filteredGenreList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genre Dropdown
        PopupMenuButton<GenreModel>(
          onSelected: (value) => _addItem(value),
          color: AppColors.panelBackground2,
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false, // Allows customization with custom widget
              child: StatefulBuilder(builder: (context, setStateMenu) {
                return SizedBox(
                  width: 300, // Adjust width
                  child: PageProvider().allGenres!.length == PageProvider().filteredGenreList.length
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
                          childAspectRatio: PageProvider().allGenres!.length == PageProvider().filteredGenreList.length ? 2 : 2,
                          children: PageProvider().allGenres!.where((genre) => !PageProvider().filteredGenreList.contains(genre)).map((genre) {
                            final isSelected = PageProvider().filteredGenreList.contains(genre);

                            return InkWell(
                              borderRadius: AppColors.borderRadiusAll,
                              onTap: () {
                                setState(() {
                                  setStateMenu(() {
                                    if (isSelected) {
                                      PageProvider().filteredGenreList.remove(genre);
                                    } else {
                                      PageProvider().filteredGenreList.add(genre);
                                    }
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
          children: PageProvider().filteredGenreList.map((genre) {
            return GestureDetector(
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
