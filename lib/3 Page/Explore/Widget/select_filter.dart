import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class SelectFilter extends StatefulWidget {
  const SelectFilter({super.key});

  @override
  State<SelectFilter> createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  final List<String> genres = ["Drama", "Action", "Comedy", "a1b2c3d4e5f6g7h8ı9i10", "Horror", "Sci-Fi"];
  final List<String> selectedGenres = [];

  void _addItem(String item) {
    if (!selectedGenres.contains(item)) {
      setState(() {
        selectedGenres.add(item);
      });
    }
  }

  void _removeItem(String item) {
    setState(() {
      selectedGenres.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genre Dropdown
        PopupMenuButton<String>(
          onSelected: (value) => _addItem(value),
          color: AppColors.panelBackground2,
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false, // Allows customization with custom widget
              child: StatefulBuilder(builder: (context, setStateMenu) {
                return SizedBox(
                  width: 300, // Adjust width
                  child: genres.length == selectedGenres.length
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
                          childAspectRatio: genres.length == selectedGenres.length ? 2 : 2,
                          children: genres.where((genre) => !selectedGenres.contains(genre)).map((genre) {
                            final isSelected = selectedGenres.contains(genre);

                            return InkWell(
                              borderRadius: AppColors.borderRadiusAll,
                              onTap: () {
                                setState(() {
                                  setStateMenu(() {
                                    if (isSelected) {
                                      selectedGenres.remove(genre);
                                    } else {
                                      selectedGenres.add(genre);
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
                                  genre,
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
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.7,
          children: selectedGenres.map((genre) {
            return InkWell(
              borderRadius: AppColors.borderRadiusAll,
              onTap: () {
                _removeItem(genre);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: AppColors.panelBackground2,
                  borderRadius: AppColors.borderRadiusAll,
                ),
                child: AutoSizeText(
                  genre,
                  maxLines: 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
