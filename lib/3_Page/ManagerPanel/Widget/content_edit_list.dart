import 'package:blackbox_db/3_Page/ManagerPanel/Widget/manager_panel_content_item.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentEditList extends StatelessWidget {
  const ContentEditList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    late final managerPanelProvider = context.read<ManagerPanelProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Search Content',
                  ),
                  onEditingComplete: () async {
                    await managerPanelProvider.searchContent(
                      searchText: textController.text,
                      contentType: ContentTypeEnum.MOVIE,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  managerPanelProvider.addContentItem();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          managerPanelProvider.contentList.isEmpty
              ? const Center(
                  child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('No Data'),
                ))
              : SizedBox(
                  width: 620,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: context.watch<ManagerPanelProvider>().contentList.length,
                    itemBuilder: (context, index) {
                      return ManagerPanelContentItem(
                        key: ValueKey(managerPanelProvider.contentList[index].id),
                        contentModel: managerPanelProvider.contentList[index],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
