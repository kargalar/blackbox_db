import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  List<ShowcaseContentModel> contentListMovie = [];
  List<ShowcaseContentModel> contentListGame = [];
  List<ShowcaseContentModel> trendMovieList = [];
  List<ShowcaseContentModel> friendsLastActivities = [];

  @override
  void initState() {
    super.initState();

    getContent();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Trend Filmler", style: TextStyle(fontSize: 20)),
                    ContentList(
                      contentList: trendMovieList,
                      showcaseType: ShowcaseTypeEnum.TREND,
                    ),
                    Text("Trend Oyunlar", style: TextStyle(fontSize: 20)),
                    ContentList(
                      contentList: contentListGame,
                      showcaseType: ShowcaseTypeEnum.TREND,
                    ),
                  ],
                ),
                SizedBox(width: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Arkaşlarının Aktiviteleri", style: TextStyle(fontSize: 20)),
                    ContentList(
                      contentList: friendsLastActivities,
                      showcaseType: ShowcaseTypeEnum.ACTIVITY,
                    ),
                    Text("Önerilenler", style: TextStyle(fontSize: 20)),
                    ContentList(
                      contentList: contentListMovie,
                      showcaseType: ShowcaseTypeEnum.FLAT,
                    ),
                    // çok beklenenler
                    // sana benzer kullanıcılar
                  ],
                ),
              ],
            ),
          );
  }

  void getContent() async {
    try {
      ExploreProvider().currentPageIndex = 0;

      // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
      // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
      // TODO: contentType null ise farklı istek atacak
      if (!isLoading) {
        isLoading = true;
        setState(() {});
      }

      final response1 = await ServerManager().getUserContents(
        contentType: ContentTypeEnum.MOVIE,
        userId: user.id,
      );

      contentListMovie = response1['contentList'];
      // sadece ilk 5 i al
      contentListMovie = contentListMovie.length > 5 ? contentListMovie.sublist(0, 5) : contentListMovie;

      final response2 = await ServerManager().getUserContents(
        contentType: ContentTypeEnum.GAME,
        userId: user.id,
      );

      contentListGame = response2['contentList'];

      final response3 = await ServerManager().getTrendMovies(
        contentType: ContentTypeEnum.MOVIE,
      );

      trendMovieList = response3['contentList'];

      final response4 = await ServerManager().getFriendActivities();

      friendsLastActivities = response4['contentList'];

      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
