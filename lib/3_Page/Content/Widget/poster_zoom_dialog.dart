import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Future<void> showPosterZoomDialog({
  required BuildContext context,
  required String? posterPath,
  required ContentTypeEnum contentType,
  required String heroTag,
}) async {
  String? imageURL;
  if (posterPath != null) {
    if (contentType == ContentTypeEnum.MOVIE) {
      imageURL = "https://image.tmdb.org/t/p/original$posterPath";
    } else if (contentType == ContentTypeEnum.GAME) {
      imageURL = "https://images.igdb.com/igdb/image/upload/t_original/$posterPath.jpg";
    }
  }

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.black.withOpacity(0.8),
    pageBuilder: (ctx, anim, secAnim) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (ctx, anim, secAnim, child) {
      return FadeTransition(
        opacity: anim,
        child: Material(
          type: MaterialType.transparency,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenW = constraints.maxWidth;
              final screenH = constraints.maxHeight;
              // Start with a large but bounded poster size (keep 2:3 ratio)
              final maxW = screenW * 0.92;
              final maxH = screenH * 0.92;
              final ratioW = maxW;
              final ratioH = ratioW * 1.5; // 2:3 => h = w * 1.5
              double initW = ratioW;
              double initH = ratioH;
              if (initH > maxH) {
                initH = maxH;
                initW = initH / 1.5;
              }

              return Stack(
                children: [
                  // Tap outside to dismiss
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  // Poster with zoom
                  Center(
                    child: Hero(
                      tag: heroTag,
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 5.0,
                        panEnabled: true,
                        clipBehavior: Clip.none,
                        boundaryMargin: const EdgeInsets.all(64),
                        child: SizedBox(
                          width: initW,
                          height: initH,
                          child: imageURL != null
                              ? CachedNetworkImage(
                                  imageUrl: imageURL,
                                  fit: BoxFit.contain,
                                )
                              : Container(color: Colors.black12),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
