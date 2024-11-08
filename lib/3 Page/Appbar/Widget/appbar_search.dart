import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
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
  late final appbarProvider = context.read<PageProvider>();

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }

  void search() {
    appbarProvider.search(controller.text);
    controller.clear();
  }
}
