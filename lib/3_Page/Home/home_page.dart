import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/3_Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/content_types_statistics.dart';
import 'package:blackbox_db/3_Page/ManagerPanel/Widget/Statistics/movie_genres_statistics.dart';
import 'package:blackbox_db/3_Page/Profile/Sections/profile_reviews.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/7_Enum/showcase_type_enum.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
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
        : LayoutBuilder(builder: (screenContext, constraints) {
            if (screenWidth < 600) {
              // Mobile UI
              return SizedBox();
            } else {
              // Desktop UI
              return SingleChildScrollView(
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
          });
  }

  void getContent() async {
    try {
      ExploreProvider().currentPageIndex = 0;

      if (!isLoading) {
        isLoading = true;
        setState(() {});
      }

      // Recommendations için ExternalApiService kullan, diğerleri için MigrationService
      final results = await Future.wait([
        _getRecommendationsFromExternalAPI(), // YENİ: ExternalApiService
        MigrationService().getTrendContents(
          contentType: ContentTypeEnum.MOVIE,
        ),
        MigrationService().getTrendContents(
          contentType: ContentTypeEnum.GAME,
        ),
        MigrationService().getFriendActivities(
          contentType: ContentTypeEnum.MOVIE,
        ),
        MigrationService().getFriendActivities(
          contentType: ContentTypeEnum.GAME,
        ),
        MigrationService().getTopReviews(),
      ]);

      recommendedMovieList = results[0] as List<ShowcaseContentModel>;
      trendMovieList = (results[1] as Map<String, dynamic>)['contentList'];
      trendGameList = (results[2] as Map<String, dynamic>)['contentList'];
      friendsLastMovieActivities = (results[3] as Map<String, dynamic>)['contentList'];
      friendsLastGameActivities = (results[4] as Map<String, dynamic>)['contentList'];
      topReviews = results[5] as List<UserReviewModel>;

      if (recommendedMovieList.length > 5) {
        recommendedMovieList = recommendedMovieList.sublist(0, 5);
      }

      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint('Home page content error: $e');
      isLoading = false;
      setState(() {});
    }
  }

  /// ExternalApiService ile film önerileri al
  Future<List<ShowcaseContentModel>> _getRecommendationsFromExternalAPI() async {
    try {
      final recommendations = await ExternalApiService().getMovieRecommendations(
        userId: loginUser!.id,
      );

      // External API response'unu ShowcaseContentModel'e çevir
      return recommendations.map((movie) {
        String? posterPath = movie['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}' : null;

        return ShowcaseContentModel(
          contentId: movie['id'],
          posterPath: posterPath,
          contentType: ContentTypeEnum.MOVIE,
          isFavorite: movie['user_is_favorite'] ?? false,
          contentStatus: movie['user_content_status_id'] != null ? ContentStatusEnum.values[movie['user_content_status_id'] - 1] : null,
          isConsumeLater: movie['user_is_consume_later'] ?? false,
          rating: movie['user_rating']?.toDouble(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Recommendations error: $e');
      return [];
    }
  }
}
