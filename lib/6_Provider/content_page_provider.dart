import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:flutter/material.dart';

class ContentPageProvider with ChangeNotifier {
  static final ContentPageProvider _instance = ContentPageProvider._internal();

  factory ContentPageProvider() {
    return _instance;
  }

  ContentPageProvider._internal();

  ContentModel? contentModel;

  List<ReviewModel> reviewList = [];
  List<ContentLogModel> userLogs = [];

  // ? contentId null ise contentPage de demek

  Future<void> contentUserAction({
    required ContentTypeEnum contentType,
    int? contentId,
    required ContentStatusEnum? contentStatus,
    required double? rating,
    required bool isFavorite,
    required bool isConsumeLater,
    String? review,
  }) async {
    // If marked as CONSUMED, auto-clear 'watch later'
    final bool effectiveConsumeLater = (contentStatus == ContentStatusEnum.CONSUMED) ? false : isConsumeLater;
    // Build user log payload
    final ContentLogModel userLog = ContentLogModel(
      userId: loginUser!.id,
      contentID: contentId ?? contentModel!.id!,
      contentType: contentType,
      contentStatus: contentStatus,
      rating: rating,
      isFavorite: isFavorite,
      isConsumeLater: effectiveConsumeLater,
      review: review,
    );

    // eğer content page de ise değişiklikleri kullanıcıya göstermek için
    if (contentId == null) {
      // Snapshot previous state to compute optimistic deltas
      final bool wasFavorite = contentModel!.isFavorite ?? false;
      final ContentStatusEnum? wasStatus = contentModel!.contentStatus;

      // Apply user flags immediately (optimistic)
      contentModel!.isConsumeLater = effectiveConsumeLater;
      contentModel!.isFavorite = isFavorite;
      contentModel!.contentStatus = contentStatus;
      final double? previousRating = contentModel!.rating;
      contentModel!.rating = rating;

      // Optimistically adjust counts
      // Favorite count
      final int favDelta = (isFavorite && !wasFavorite) ? 1 : ((!isFavorite && wasFavorite) ? -1 : 0);
      if (favDelta != 0) {
        final current = contentModel!.favoriCount ?? 0;
        contentModel!.favoriCount = (current + favDelta).clamp(0, 1 << 30);
      }

      // Consume (watch) count: increment when status becomes CONSUMED, decrement if removed
      final bool wasConsumed = wasStatus == ContentStatusEnum.CONSUMED;
      final bool isConsumedNow = contentStatus == ContentStatusEnum.CONSUMED;
      final int consumeDelta = (isConsumedNow && !wasConsumed) ? 1 : ((!isConsumedNow && wasConsumed) ? -1 : 0);
      if (consumeDelta != 0) {
        final current = contentModel!.consumeCount ?? 0;
        contentModel!.consumeCount = (current + consumeDelta).clamp(0, 1 << 30);
      }

      if (review != null) {
        // Optimistically increment review count
        contentModel!.reviewCount = (contentModel!.reviewCount ?? 0) + 1;
        reviewList.insert(
          0,
          ReviewModel(
            id: reviewList.length + 1,
            picturePath: loginUser!.picturePath,
            userName: loginUser!.username,
            userId: loginUser!.id,
            text: review,
            createdAt: DateTime.now(),
            rating: rating,
            isFavorite: isFavorite,
            likeCount: 0,
            commentCount: 0,
            isLikedByCurrentUser: false,
          ),
        );
      }

      // Optimistically update rating distribution buckets (1..5)
      List<int> dist = (contentModel!.ratingDistribution == null || contentModel!.ratingDistribution!.length != 5) ? List<int>.filled(5, 0) : List<int>.from(contentModel!.ratingDistribution!);
      // Decrement previous bucket if existed
      if (previousRating != null && previousRating > 0) {
        final prevIdx = previousRating.round().clamp(1, 5) - 1;
        if (prevIdx >= 0 && prevIdx < 5 && dist[prevIdx] > 0) dist[prevIdx] -= 1;
      }
      // Increment new bucket
      if (rating != null && rating > 0) {
        final newIdx = rating.round().clamp(1, 5) - 1;
        if (newIdx >= 0 && newIdx < 5) dist[newIdx] += 1;
      }
      contentModel!.ratingDistribution = dist;

      notifyListeners();
    }

    // Persist to backend
    await MigrationService().contentUserAction(contentLogModel: userLog);

    // Refresh content detail from Supabase for user-specific fields (keep optimistic aggregates)
    try {
      final refreshed = await MigrationService().getContentDetail(
        contentId: userLog.contentID,
        contentType: userLog.contentType,
        // userId is optional; service falls back to currentUserId
      );
      if (contentId == null) {
        // Merge user-specific fields
        contentModel!.contentStatus = refreshed.contentStatus;
        contentModel!.rating = refreshed.rating;
        contentModel!.isFavorite = refreshed.isFavorite;
        contentModel!.isConsumeLater = refreshed.isConsumeLater;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to refresh content detail after action: $e');
    }
  }

  Future<void> fetchUserLogsForContent(int contentId) async {
    try {
      userLogs = await MigrationService().getUserLogsForContent(contentId: contentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to fetch user logs: $e');
    }
  }

  Future<void> updateUserLogEntry({
    required int logId,
    required int contentId,
    ContentStatusEnum? contentStatus,
    double? rating,
    bool? isFavorite,
    bool? isConsumeLater,
    String? reviewText,
  }) async {
    try {
      await MigrationService().updateUserLog(
        logId: logId,
        contentId: contentId,
        contentStatus: contentStatus,
        rating: rating,
        isFavorite: isFavorite,
        isConsumeLater: isConsumeLater,
        reviewText: reviewText,
      );

      // Refresh lists and content detail after update
      await fetchUserLogsForContent(contentId);
      if (contentModel != null && contentModel!.id == contentId) {
        final refreshed = await MigrationService().getContentDetail(
          contentId: contentId,
          contentType: contentModel!.contentType,
        );
        contentModel = refreshed;
        // Also refresh reviews list for this content so duplicates/edits reflect
        try {
          reviewList = await MigrationService().getContentReviews(contentId: contentId);
        } catch (_) {}
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update user log: $e');
    }
  }

  Future<void> deleteUserLogEntry({
    required int logId,
    required int contentId,
  }) async {
    try {
      await MigrationService().deleteUserLog(logId: logId, contentId: contentId);
      await fetchUserLogsForContent(contentId);
      if (contentModel != null && contentModel!.id == contentId) {
        final refreshed = await MigrationService().getContentDetail(
          contentId: contentId,
          contentType: contentModel!.contentType,
        );
        contentModel = refreshed;
        // Refresh reviews as well
        try {
          reviewList = await MigrationService().getContentReviews(contentId: contentId);
        } catch (_) {}
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to delete user log: $e');
    }
  }
}
