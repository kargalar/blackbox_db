import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarExploreButton extends StatelessWidget {
  const AppbarExploreButton({super.key});

  @override
  Widget build(BuildContext context) {
    late final appbarProvider = context.read<AppbarProvider>();
// !!!!!!!!!!!!!!!! ayrı ayrı olmasın dzüelt wigetlştır
    return Row(
      children: [
        InkWell(
          borderRadius: AppColors.borderRadiusAll,
          onTap: () {
            appbarProvider.updatePage(2);
          },
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Movies"),
          ),
        ),
        InkWell(
          borderRadius: AppColors.borderRadiusAll,
          onTap: () {
            appbarProvider.updatePage(3);
          },
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Games"),
          ),
        ),
        InkWell(
          borderRadius: AppColors.borderRadiusAll,
          onTap: () {
            appbarProvider.updatePage(4);
          },
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Books"),
          ),
        ),
      ],
    );
  }
}
