import 'package:blackbox_db/2%20General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
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
        const SizedBox(height: 20),
        // poster
        SizedBox(
          height: 350,
          child: ContentPoster(
            posterPath: contentModel!.posterPath,
            contentType: contentModel.contentType,
            cacheSize: 2000,
          ),
        ),
        // movie stats
        Container(
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
