import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentUserAction extends StatelessWidget {
  const ContentUserAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final contentPageProvider = context.read<ContentPageProvider>();

    return Container(
      color: AppColors.panelBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              contentPageProvider.watchContent();
            },
            child: const Text("Watch"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Favori"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("List"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Review"),
          ),
        ],
      ),
    );
  }
}
