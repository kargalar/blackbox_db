import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:flutter/material.dart';

class SelectFilter extends StatefulWidget {
  const SelectFilter({
    super.key,
    required this.title,
    required this.allItemList,
    this.selectedItem,
    this.filteredItemList,
    required this.addItem,
    required this.removeItem,
  });

  final String title;
  final List<dynamic> allItemList;
  final dynamic selectedItem;
  final List<dynamic>? filteredItemList;
  final Function? addItem;
  final Function? removeItem;

  @override
  State<SelectFilter> createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown
        PopupMenuButton<dynamic>(
          color: AppColors.panelBackground2,
          offset: const Offset(-95, 0),
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false, // Allows customization with custom widget
              child: StatefulBuilder(builder: (context, setStateMenu) {
                return SizedBox(
                  width: 300, // Adjust width
                  child: widget.filteredItemList != null && widget.allItemList.length == widget.filteredItemList!.length
                      ? Center(
                          child: Text(
                            "No Other Options",
                            style: TextStyle(
                              color: AppColors.dirtyWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: widget.filteredItemList != null && widget.allItemList.length == widget.filteredItemList!.length ? 2 : 2,
                          children: widget.allItemList.where((item) => widget.filteredItemList != null ? !widget.filteredItemList!.contains(item) : true).map((item) {
                            return InkWell(
                              borderRadius: AppColors.borderRadiusAll,
                              onTap: () {
                                setState(() {
                                  setStateMenu(() {
                                    widget.addItem!(item);
                                  });
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.panelBackground,
                                  borderRadius: AppColors.borderRadiusAll,
                                ),
                                child: AutoSizeText(
                                  item.name,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                );
              }),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        widget.filteredItemList != null
            ? Wrap(
                children: widget.filteredItemList!.map((item) {
                  return InkWell(
                    onTap: () {
                      widget.removeItem!(item);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.panelBackground2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            item.name,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            : widget.selectedItem == null
                ? Container()
                : InkWell(
                    onTap: () {
                      widget.removeItem!(widget.selectedItem);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.panelBackground2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            widget.selectedItem.name,
                          ),
                        ],
                      ),
                    ),
                  ),
      ],
    );
  }
}
