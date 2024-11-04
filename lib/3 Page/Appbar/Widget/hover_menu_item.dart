import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (filteredContentType.contains(widget.contentType)) {
          filteredContentType.remove(widget.contentType);
        } else {
          filteredContentType.add(widget.contentType);
        }

        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            filteredContentType.contains(widget.contentType) ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
            Text(widget.contentType.toString().split('.').last),
          ],
        ),
      ),
    );
  }
}
