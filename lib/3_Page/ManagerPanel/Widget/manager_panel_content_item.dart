import 'package:blackbox_db/2_General/Widget/Content/Widget/content_poster.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagerPanelContentItem extends StatefulWidget {
  const ManagerPanelContentItem({
    super.key,
    required this.contentModel,
  });

  final ContentModel contentModel;

  @override
  State<ManagerPanelContentItem> createState() => _ManagerPanelContentItemState();
}

class _ManagerPanelContentItemState extends State<ManagerPanelContentItem> {
  late final managerPanelProvider = context.read<ManagerPanelProvider>();

  late bool isEdit;

  late final TextEditingController titleController = TextEditingController(text: widget.contentModel.title);
  late final TextEditingController descriptionController = TextEditingController(text: widget.contentModel.description ?? "");

  @override
  void initState() {
    super.initState();

    if (widget.contentModel.favoriCount != null && widget.contentModel.favoriCount! < 0) {
      isEdit = true;
    } else {
      isEdit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: ContentPoster(
              posterPath: widget.contentModel.posterPath,
              contentType: widget.contentModel.contentType,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          controller: titleController,
                          style: TextStyle(fontSize: 18),
                          enabled: isEdit,
                        ),
                      ),
                      if (widget.contentModel.favoriCount != null && widget.contentModel.favoriCount! < 0) ...[
                        // save
                        IconButton(
                          onPressed: () async {
                            await managerPanelProvider.addContent(
                              contentModel: ContentModel(
                                id: widget.contentModel.id,
                                title: titleController.text,
                                description: descriptionController.text,
                                contentType: widget.contentModel.contentType,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check),
                        ),
                      ] else ...[
                        // delete
                        IconButton(
                          onPressed: () async {
                            await managerPanelProvider.deleteContent(contentID: widget.contentModel.id!);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        // edit
                        IconButton(
                          onPressed: () async {
                            isEdit = !isEdit;
                            setState(() {});

                            if (!isEdit) {
                              await managerPanelProvider.updateContent(
                                contentModel: ContentModel(
                                  id: widget.contentModel.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  contentType: widget.contentModel.contentType,
                                  posterPath: widget.contentModel.posterPath,
                                  releaseDate: widget.contentModel.releaseDate,
                                  creatorList: widget.contentModel.creatorList,
                                  cast: widget.contentModel.cast,
                                  genreList: widget.contentModel.genreList,
                                  rating: widget.contentModel.rating,
                                  length: widget.contentModel.length,
                                  consumeCount: widget.contentModel.consumeCount,
                                  favoriCount: widget.contentModel.favoriCount,
                                  listCount: widget.contentModel.listCount,
                                  reviewCount: widget.contentModel.reviewCount,
                                  ratingDistribution: widget.contentModel.ratingDistribution,
                                  contentStatus: widget.contentModel.contentStatus,
                                  isFavorite: widget.contentModel.isFavorite,
                                  isConsumeLater: widget.contentModel.isConsumeLater,
                                ),
                              );
                            }
                          },
                          icon: Icon(isEdit ? Icons.save : Icons.edit),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    maxLines: 5,
                    controller: descriptionController,
                    style: TextStyle(fontSize: 13),
                    enabled: isEdit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
