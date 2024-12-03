import 'package:blackbox_db/2%20General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/6%20Provider/movie_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentCover extends StatelessWidget {
  const ContentCover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final movieModel = context.read<MoviePageProvider>().movieModel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        // poster
        ContentPoster.contentPage(
          posterPath: movieModel!.posterPath,
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
                        movieModel.consumeCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("Watch"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        movieModel.favoriCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("Favori"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        movieModel.listCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text("List"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        movieModel.reviewCount.toString(),
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
                  for (var i = 0; i < movieModel.ratingDistribution.length; i++)
                    Column(
                      children: [
                        Text(
                          "${movieModel.ratingDistribution[i]} ",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text("${i + 1}"),
                      ],
                    ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        movieModel.rating.toString(),
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
