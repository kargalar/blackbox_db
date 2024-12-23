import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarSearch extends StatefulWidget {
  const AppbarSearch({
    super.key,
  });

  @override
  State<AppbarSearch> createState() => _AppbarSearchState();
}

class _AppbarSearchState extends State<AppbarSearch> {
  late final generalProvider = context.read<GeneralProvider>();

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        searchFilter(),
        const SizedBox(width: 10),
        SizedBox(
          width: 250,
          height: 43,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.panelBackground2,
              borderRadius: AppColors.borderRadiusAll,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  // search bar
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 15),
                      ),
                      onEditingComplete: () {
                        search();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        search();
                      },
                      child: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  DropdownButton<String> searchFilter() {
    return DropdownButton<String>(
      value: generalProvider.searchFilter == ContentTypeEnum.MOVIE
          ? "Movie"
          : generalProvider.searchFilter == ContentTypeEnum.GAME
              ? "Game"
              : "Book",
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: AppColors.text),
      underline: Container(
        height: 2,
        color: AppColors.text,
      ),
      onChanged: (String? newValue) {
        if (newValue == "Movie") {
          generalProvider.searchFilter = ContentTypeEnum.MOVIE;
        } else if (newValue == "Game") {
          generalProvider.searchFilter = ContentTypeEnum.GAME;
        } else {
          generalProvider.searchFilter = ContentTypeEnum.BOOK;
        }

        setState(() {});
      },
      items: <String>['Movie', 'Game'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void search() async {
    if (controller.text.isEmpty) return;
    await generalProvider.search(controller.text);
    controller.clear();
  }
}
