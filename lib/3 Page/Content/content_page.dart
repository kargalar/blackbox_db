import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/cast_model.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:blackbox_db/8%20Model/creator_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/platform_model.dart';
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
    coverPath: "https://image.tmdb.org/t/p/original/s2VAydm53Odgafoto5NPLUeQgkX.jpg",
    contentType: ContentTypeEnum.MOVIE,
    year: DateTime(2024),
    creatorList: [CreatorModel(id: 0, name: "Panah Panhani")],
    description: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps exploding into car karaoke. Only the older brother is quiet.",
    genreList: [GenreModel(id: 0, title: "Action"), GenreModel(id: 1, title: "Sci-Fi"), GenreModel(id: 2, title: "Drama")],
    lenght: 138,
    platformList: [PlatformModel(id: 0, title: "Netflix")],
    cast: [CastModel(id: 0, name: "John David Washington"), CastModel(id: 1, name: "Robert Pattinson"), CastModel(id: 2, name: "Elizabeth Debicki")],
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
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // cover
          Column(
            children: [
              Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(contentModel.coverPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // movie stats
              Container(
                color: AppColors.panelBackground,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              contentModel.watchCount.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Text("Watch"),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              contentModel.favoriCount.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Text("Favori"),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              contentModel.listCount.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Text("List"),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              contentModel.reviewCount.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Text("Review"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        for (var i = 0; i < contentModel.ratingDistribution.length; i++)
                          Column(
                            children: [
                              Text(
                                contentModel.ratingDistribution[i].toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text("${i + 1}"),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
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
              ],
            ),
          ),
          // user actions
          Container(
            color: AppColors.panelBackground,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
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
          ),
        ],
      ),
    );
  }
}
