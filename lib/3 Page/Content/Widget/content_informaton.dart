import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/cast_item.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentInformation extends StatelessWidget {
  const ContentInformation({super.key});

  @override
  Widget build(BuildContext context) {
    late final contentModel = context.read<ContentPageProvider>().contentModel;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            //TODO: loglarıynca move kaydediyor game ekaydedecek sprun bu
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                contentModel!.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              if (contentModel.releaseDate != null)
                Text(
                  contentModel.releaseDate!.year.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.text.withOpacity(0.6),
                  ),
                ),
            ],
          ),

          if (contentModel.creatorList != null)
            Row(
              children: [
                ...List.generate(
                  contentModel.creatorList!.length,
                  (index) {
                    return Text(
                      contentModel.creatorList![index].name,
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
              contentModel.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
          if (contentModel.genreList != null)
            Row(
              children: [
                Text(
                  contentModel.genreList!.map((e) => e.name).join(", "),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  "${contentModel.length} min",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          const SizedBox(height: 20),
          // TODO: buralar sadece isteyenler için açılacak şekilde olsun. tür, mod, actorler, platform falan. yani tasarımdaki gibi
          if (contentModel.cast != null) ...[
            SizedBox(
              width: 500,
              height: 50,
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 2),
                scrollDirection: Axis.horizontal,
                itemCount: contentModel.cast!.length,
                itemBuilder: (BuildContext context, int index) {
                  return CastItem(
                    crewModel: contentModel.cast![index],
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
