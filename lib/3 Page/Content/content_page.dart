import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({
    super.key,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  ContentModel contentModel = ContentModel(
    id: 1,
    title: "Hit the Road ",
    contentType: ContentTypeEnum.MOVIE,
    year: 2021,
    creator: ["Panah Panahi"],
    description: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps exploding into car karaoke. Only the older brother is quiet.",
    genre: ["Action", "Sci-Fi", "Drama"],
    lenght: 138,
    platform: ["Netflix"],
    cast: ["John David Washington", "Robert Pattinson", "Elizabeth Debicki"],
    watchCount: 1000,
    favoriCount: 100,
    listCount: 50,
    reviewCount: 10,
    ratingDistribution: [5, 2, 8, 22, 3],
  );

  @override
  void initState() {
    super.initState();
    // TODO: istek atıalcak loading olacak şimdilik el ile  context.read<PageProvider>().contentID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.panelBackground,
        padding: const EdgeInsets.all(20),
        child: Column(
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
              contentModel.creator.join(", "),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Text(
              contentModel.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Divider(),
            Row(
              children: [
                Text(
                  contentModel.genre.join(", "),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  "${contentModel.lenght} min",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                if (contentModel.platform != null) ...[
                  Text(
                    contentModel.platform!.join(", "),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
