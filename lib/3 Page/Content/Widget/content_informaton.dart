import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/cast_item.dart';
import 'package:blackbox_db/6%20Provider/movie_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentInformation extends StatelessWidget {
  const ContentInformation({super.key});

  @override
  Widget build(BuildContext context) {
    late final movieModel = context.read<MoviePageProvider>().movieModel;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                movieModel!.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                movieModel.releaseDate.year.toString(),
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.text.withOpacity(0.6),
                ),
              ),
            ],
          ),

          if (movieModel.creatorList != null)
            Row(
              children: [
                ...List.generate(
                  movieModel.creatorList!.length,
                  (index) {
                    return Text(
                      movieModel.creatorList![index].name,
                      style: const TextStyle(fontSize: 15),
                    );
                  },
                ),
              ],
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: 500,
            child: Text(
              movieModel.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
          if (movieModel.genreList != null)
            Row(
              children: [
                Text(
                  movieModel.genreList!.map((e) => e.title).join(", "),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  "${movieModel.length} min",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          const SizedBox(height: 20),
          // TODO: buralar sadece isteyenler için açılacak şekilde olsun. tür, mod, actorler, platform falan. yani tasarımdaki gibi
          if (movieModel.cast != null) ...[
            SizedBox(
              width: 500,
              height: 50,
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 2),
                scrollDirection: Axis.horizontal,
                itemCount: movieModel.cast!.length,
                itemBuilder: (BuildContext context, int index) {
                  return CastItem(
                    crewModel: movieModel.cast![index],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
