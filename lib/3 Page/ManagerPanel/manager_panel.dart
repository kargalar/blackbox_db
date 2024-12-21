import 'package:blackbox_db/3%20Page/ManagerPanel/Widget/panel_content_item.dart';
import 'package:blackbox_db/6%20Provider/manager_panel_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagerPanel extends StatefulWidget {
  const ManagerPanel({super.key});

  @override
  State<ManagerPanel> createState() => _ManagerPanelState();
}

class _ManagerPanelState extends State<ManagerPanel> {
  late final managerPanelProvider = context.read<ManagerPanelProvider>();

  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<ManagerPanelProvider>().isLoading
        ? const Center(child: CircularProgressIndicator())
        : managerPanelProvider.contentList.isEmpty
            ? const Center(child: Text('No Data'))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: managerPanelProvider.contentList.length,
                      itemBuilder: (context, index) {
                        // TODO: burada içeriğin bilgileri gösterilecek ve düzenlenebilecek veya silinebilecek. yapıaln değişikliklere göre güncellenmesi gerekenler güncellenecek
                        return PanelContentItem(
                          contentModel: managerPanelProvider.contentList[index],
                        );
                      },
                    ),
                  ],
                ),
              );
  }

  void getAllData() async {
    await managerPanelProvider.searchContent(
      contentType: ContentTypeEnum.MOVIE,
    );
  }
}