import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:flutter/material.dart';

class HoverMenuFilterItem extends StatefulWidget {
  const HoverMenuFilterItem({
    super.key,
    required this.contentType,
  });

  final ContentTypeEnum contentType;

  @override
  State<HoverMenuFilterItem> createState() => _HoverMenuFilterItemState();
}

class _HoverMenuFilterItemState extends State<HoverMenuFilterItem> {
  late bool showContent;

  @override
  void initState() {
    super.initState();
    if (widget.contentType == ContentTypeEnum.MOVIE) {
      showContent = showMovie;
    } else if (widget.contentType == ContentTypeEnum.BOOK) {
      showContent = showBook;
    } else if (widget.contentType == ContentTypeEnum.GAME) {
      showContent = showGame;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _filterContent();

        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            showContent ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
            Text(widget.contentType.toString().split('.').last),
          ],
        ),
      ),
    );
  }

  void _filterContent() {
    showContent = !showContent;

    if (widget.contentType == ContentTypeEnum.MOVIE) {
      showMovie = !showMovie;
    } else if (widget.contentType == ContentTypeEnum.BOOK) {
      showBook = !showBook;
    } else if (widget.contentType == ContentTypeEnum.GAME) {
      showGame = !showGame;
    }
  }
}
