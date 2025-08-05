import 'package:blackbox_db/2_General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
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
                        (contentModel.consumeCount ?? 0).toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("Watch"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        (contentModel.favoriCount ?? 0).toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("Favori"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        (contentModel.listCount ?? 0).toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("List"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        (contentModel.reviewCount ?? 0).toString(),
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
                  // Rating distribution null check
                  if (contentModel.ratingDistribution != null)
                    for (var i = 0; i < contentModel.ratingDistribution!.length; i++)
                      Column(
                        children: [
                          Text(
                            "${contentModel.ratingDistribution![i]} ",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text("${i + 1}"),
                        ],
                      ),
                  // Default rating distribution if null
                  if (contentModel.ratingDistribution == null)
                    for (var i = 0; i < 5; i++)
                      Column(
                        children: [
                          Text(
                            "0 ",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text("${i + 1}"),
                        ],
                      ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        (contentModel.rating ?? 0.0).toString(),
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
