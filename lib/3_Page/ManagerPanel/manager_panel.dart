import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/actor_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/content_types_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/most_watched_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/movie_genres_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/movie_rating_by_genre_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/movie_rating_by_year_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/content_edit_list.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/weekday_watch_count_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/user_edit_list.dart';
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

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<ManagerPanelProvider>().isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ContentEditList(),
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
                    ActorStatistics(),
                    SizedBox(height: 50),
                    ActorStatisticss(),
                    SizedBox(height: 50),
                    MovieYearStatistics(),
                    SizedBox(height: 50),
                    UserEditList(),
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

    await managerPanelProvider.getAllUser();
  }
}
