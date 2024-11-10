import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentInformation extends StatelessWidget {
  const ContentInformation({super.key});

  @override
  Widget build(BuildContext context) {
    late final contentModel = context.read<ContentPageProvider>().contentModel;

    return Container(
      color: AppColors.panelBackground2,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                contentModel.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                contentModel.year.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(
            contentModel.creatorList.map((e) => e.name).join(", "),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 500,
            child: Text(
              contentModel.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Text(
                contentModel.genreList.map((e) => e.title).join(", "),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              Text(
                "${contentModel.lenght} min",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              if (contentModel.platformList != null) ...[
                Text(
                  contentModel.platformList!.map((e) => e.title).join(", "),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          if (contentModel.cast != null) ...[
            Text(
              "Cast: ${contentModel.cast!.map((e) => e.name).join(", ")}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
