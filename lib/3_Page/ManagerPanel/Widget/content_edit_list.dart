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
          SizedBox(
            width: 620,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: managerPanelProvider.contentList.length,
              itemBuilder: (context, index) {
                // TODO: burada içeriğin bilgileri gösterilecek ve düzenlenebilecek veya silinebilecek. yapıaln değişikliklere göre güncellenmesi gerekenler güncellenecek
                return ManagerPanelContentItem(
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
