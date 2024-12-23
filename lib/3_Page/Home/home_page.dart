import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/3_Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/content_types_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/movie_genres_statistics.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_reviews.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/7_Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  List<ShowcaseContentModel> recommendedMovieList = [];
  List<ShowcaseContentModel> trendMovieList = [];
  List<ShowcaseContentModel> trendGameList = [];
  List<ShowcaseContentModel> friendsLastMovieActivities = [];
  List<ShowcaseContentModel> friendsLastGameActivities = [];
  List<UserReviewModel> topReviews = [];

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
                    if (showMovie && trendMovieList.isNotEmpty) ...[
                      Text("Trending Movies", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      ContentList(
                        contentList: trendMovieList,
                        showcaseType: ShowcaseTypeEnum.TREND,
                      ),
                    ],
                    if (showGame && trendGameList.isNotEmpty) ...[
                      Text("Trending Games", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      ContentList(
                        contentList: trendGameList,
                        showcaseType: ShowcaseTypeEnum.TREND,
                      ),
                    ],
                    ContentTypeStatistics(),
                    MovieGenreStatistics(),
                  ],
                ),
                SizedBox(width: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showMovie && friendsLastMovieActivities.isNotEmpty) ...[
                      Text("Friends' Movie Activities", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      ContentList(
                        contentList: friendsLastMovieActivities,
                        showcaseType: ShowcaseTypeEnum.ACTIVITY,
                      ),
                    ],
                    if (showGame && friendsLastGameActivities.isNotEmpty) ...[
                      Text("Friends' Game Activities", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      ContentList(
                        contentList: friendsLastGameActivities,
                        showcaseType: ShowcaseTypeEnum.ACTIVITY,
                      ),
                    ],
                    if (showMovie && recommendedMovieList.isNotEmpty) ...[
                      Text("Recommended Movies", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      ContentList(
                        contentList: recommendedMovieList,
                        showcaseType: ShowcaseTypeEnum.FLAT,
                      ),
                    ],
                    if (topReviews.isNotEmpty) ...[
                      Text("Top Reviews", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 0.5.sw,
                        child: ProfileReviews(
                          reviewList: topReviews,
                        ),
                      ),
                    ],
                    SizedBox(height: 100),
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

      final results = await Future.wait([
        ServerManager().getRecommendedContents(
          contentType: ContentTypeEnum.MOVIE,
          userId: loginUser!.id,
        ),
        ServerManager().getTrendContents(
          contentType: ContentTypeEnum.MOVIE,
        ),
        ServerManager().getTrendContents(
          contentType: ContentTypeEnum.GAME,
        ),
        ServerManager().getFriendActivities(
          contentType: ContentTypeEnum.MOVIE,
        ),
        ServerManager().getFriendActivities(
          contentType: ContentTypeEnum.GAME,
        ),
        ServerManager().getTopReviews(),
      ]);

      recommendedMovieList = results[0]['contentList'];
      trendMovieList = results[1]['contentList'];
      trendGameList = results[2]['contentList'];
      friendsLastMovieActivities = results[3]['contentList'];
      friendsLastGameActivities = results[4]['contentList'];
      topReviews = results[5];

      if (recommendedMovieList.length > 5) {
        recommendedMovieList = recommendedMovieList.sublist(0, 5);
      }

      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
