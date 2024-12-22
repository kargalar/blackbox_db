import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/content_types_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/most_watched_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/movie_genres_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/panel_content_item.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/weekday_watch_count_statistics.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
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
                                  return PanelContentItem(
                                    contentModel: managerPanelProvider.contentList[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 50),
                        MostWatchedStatistics(),
                        SizedBox(height: 50),
                        WeekdayWatchCountStatistics(),
                        SizedBox(height: 50),
                        ContentTypeStatistics(),
                        SizedBox(height: 50),
                        MovieGenreStatistics(),
                        SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              );
  }

  void getAllData() async {
    await managerPanelProvider.searchContent(
      contentType: ContentTypeEnum.MOVIE,
    );
    await managerPanelProvider.getStatistics();
  }
}
