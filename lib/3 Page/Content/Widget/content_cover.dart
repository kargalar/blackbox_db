import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentCover extends StatelessWidget {
  const ContentCover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final contentModel = context.read<ContentPageProvider>().contentModel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: NetworkImage("asd/cover/${contentModel.id}"),
              image: NetworkImage(
                contentModel.contentType == ContentTypeEnum.MOVIE
                    ? "https://assets.mubicdn.net/images/notebook/post_images/22267/images-w1400.jpg?1474980339"
                    : contentModel.contentType == ContentTypeEnum.BOOK
                        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCqYZBEzzpdbFogx5zqxp_cOtdRQw5oL3lyg&s"
                        : "https://images.igdb.com/igdb/image/upload/t_cover_big/co5xex.jpg",
              ),
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
                        contentModel.consumeCount.toString(),
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
                          "${contentModel.ratingDistribution[i]} ",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text("${i + 1}"),
                      ],
                    ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        contentModel.rating.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("Rating"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}