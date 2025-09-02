import 'package:blackbox_db/2_General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/3_Page/Content/Widget/content_stats.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:blackbox_db/3_Page/Content/Widget/poster_zoom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentCover extends StatelessWidget {
  const ContentCover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Watch provider so stats refresh on user actions
    final contentModel = context.watch<ContentPageProvider>().contentModel;

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
            heroTag: 'poster_${contentModel.id}',
            onTap: () {
              showPosterZoomDialog(
                context: context,
                posterPath: contentModel.posterPath,
                contentType: contentModel.contentType,
                heroTag: 'poster_${contentModel.id}',
              );
            },
          ),
        ),
        // stats + rating distribution
        Padding(
          padding: const EdgeInsets.all(12),
          child: ContentStats(content: contentModel),
        ),
      ],
    );
  }
}
