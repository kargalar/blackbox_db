import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:flutter/material.dart';

/// Example provider showing how to migrate from ServerManager to MigrationService
/// This provider demonstrates the minimal changes needed to use Supabase
class HomeProviderExample extends ChangeNotifier {
  final MigrationService _migrationService = MigrationService();

  bool isLoading = false;
  List<ShowcaseContentModel> recommendedMovieList = [];
  List<ShowcaseContentModel> trendMovieList = [];
  List<ShowcaseContentModel> trendGameList = [];
  List<ShowcaseContentModel> friendsLastMovieActivities = [];
  List<ShowcaseContentModel> friendsLastGameActivities = [];
  List<UserReviewModel> topReviews = [];

  Future<void> getContent() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      // Execute multiple requests in parallel
      final results = await Future.wait([
        // Old: ServerManager().getRecommendedContents(...)
        // New: Use MigrationService with same method signature
        _migrationService.getRecommendedContents(
          userId: loginUser!.id,
          contentType: ContentTypeEnum.MOVIE,
        ),

        _migrationService.getTrendContents(
          contentType: ContentTypeEnum.MOVIE,
        ),

        _migrationService.getTrendContents(
          contentType: ContentTypeEnum.GAME,
        ),

        _migrationService.getFriendActivities(
          contentType: ContentTypeEnum.MOVIE,
        ),

        _migrationService.getFriendActivities(
          contentType: ContentTypeEnum.GAME,
        ),

        _migrationService.getTopReviews(
          contentType: null, // All content types
        ),
      ]);

      // Extract results - same as before but with proper casting
      recommendedMovieList = (results[0] as Map<String, dynamic>)['contentList'] as List<ShowcaseContentModel>;
      trendMovieList = (results[1] as Map<String, dynamic>)['contentList'] as List<ShowcaseContentModel>;
      trendGameList = (results[2] as Map<String, dynamic>)['contentList'] as List<ShowcaseContentModel>;
      friendsLastMovieActivities = (results[3] as Map<String, dynamic>)['contentList'] as List<ShowcaseContentModel>;
      friendsLastGameActivities = (results[4] as Map<String, dynamic>)['contentList'] as List<ShowcaseContentModel>;
      topReviews = results[5] as List<UserReviewModel>;

      // Limit results if needed
      if (recommendedMovieList.length > 5) {
        recommendedMovieList = recommendedMovieList.sublist(0, 5);
      }
    } catch (e) {
      debugPrint('Error loading home content: $e');
      // Handle error appropriately
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Example of content search with Supabase
  Future<List<ShowcaseContentModel>> searchContent({
    required String query,
    required ContentTypeEnum contentType,
    int page = 1,
  }) async {
    try {
      final result = await _migrationService.searchContent(
        query: query,
        contentType: contentType,
        page: page,
      );

      return result['contentList'] as List<ShowcaseContentModel>;
    } catch (e) {
      debugPrint('Error searching content: $e');
      return [];
    }
  }

  // Example of user content interaction
  Future<void> updateUserContentAction({
    required int contentId,
    required ContentTypeEnum contentType,
    double? rating,
    bool? isFavorite,
    bool? isConsumeLater,
    String? review,
  }) async {
    try {
      // Create content log model
      final contentLogModel = ContentLogModel(
        userId: loginUser!.id, // Current user ID
        contentID: contentId,
        contentType: contentType,
        rating: rating,
        isFavorite: isFavorite,
        isConsumeLater: isConsumeLater,
        review: review,
      );

      await _migrationService.contentUserAction(
        contentLogModel: contentLogModel,
      );

      // Refresh data if needed
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user content action: $e');
      rethrow;
    }
  }
}
