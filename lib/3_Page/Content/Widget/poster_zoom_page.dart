import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterZoomPage extends StatelessWidget {
  final String? posterPath;
  final ContentTypeEnum contentType;
  final String heroTag;
  const PosterZoomPage({super.key, required this.posterPath, required this.contentType, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    String? imageURL;
    if (posterPath != null) {
      if (contentType == ContentTypeEnum.MOVIE) {
        imageURL = "https://image.tmdb.org/t/p/original$posterPath";
      } else if (contentType == ContentTypeEnum.GAME) {
        imageURL = "https://images.igdb.com/igdb/image/upload/t_original/$posterPath.jpg";
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final screenH = constraints.maxHeight;
          return Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 5.0,
                panEnabled: true,
                clipBehavior: Clip.none,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(64),
                child: SizedBox(
                  width: screenW,
                  height: screenH,
                  child: imageURL != null
                      ? CachedNetworkImage(
                          imageUrl: imageURL,
                          fit: BoxFit.contain,
                        )
                      : Container(color: Colors.black12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
