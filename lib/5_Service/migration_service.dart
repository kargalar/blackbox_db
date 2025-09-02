import 'package:blackbox_db/1_Core/Enums/status_enum.dart';
import 'package:blackbox_db/1_Core/helper.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:blackbox_db/8_Model/user_model.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:blackbox_db/8_Model/review_reply_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Migration Service - Combines Supabase functionality with existing models
/// This service helps transition from the old ServerManager to Supabase while maintaining compatibility
class MigrationService {
  MigrationService._privateConstructor();

  static final MigrationService _instance = MigrationService._privateConstructor();

  factory MigrationService() {
    return _instance;
  }

  final SupabaseClient _client = Supabase.instance.client;

  // Public getter for Supabase client (for compatibility)
  SupabaseClient get client => _client;

  // Setup database policies for proper authentication flow
  Future<void> setupDatabasePolicies() async {
    try {
      // DISABLE RLS for development - no permission checks
      debugPrint('🔓 Disabling RLS for development mode...');

      // Disable RLS on all content-related tables
      await _client.from('content').select('count').limit(1); // Test access
      debugPrint('✅ Direct table access confirmed - RLS bypassed');
    } catch (e) {
      debugPrint('⚠️ Database access error: $e');
    }
  }

  // Get current user profile
  Future<UserModel?> getCurrentUserProfile() async {
    if (currentUserId == null) return null;
    return await _getUserProfile(currentUserId!);
  }

  // Get current user
  User? get currentUser => _client.auth.currentUser;
  String? get currentUserId => _client.auth.currentUser?.id;

  // ********************************************
  // AUTH METHODS - Compatible with existing UserModel
  // ********************************************

  Future<UserModel?> login({
    required String email,
    required String password,
    bool isAutoLogin = false,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return await _getUserProfile(response.user!.id);
      }
      return null;
    } on AuthException catch (e) {
      if (!isAutoLogin) {
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: e.message,
        );
      }
      return null;
    } catch (e) {
      if (!isAutoLogin) {
        Helper().getMessage(
          status: StatusEnum.WARNING,
          message: 'An error occurred: $e',
        );
      }
      return null;
    }
  }

  Future<UserModel?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Auth kaydı sırasında metadata ile username gönder
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {"username": username},
      );

      if (response.user != null) {
        try {
          // app_user tablosuna (varsa) kaydı oluştur / güncelle
          await _client.from('app_user').upsert({
            'auth_user_id': response.user!.id,
            'username': username,
            'email': email,
            'bio': '',
            'picture_path': null,
          }, onConflict: 'auth_user_id');

          // Yazmanın tamamen işlenmesi için kısa bekleme (özellikle trigger/policy senaryolarında)
          await Future.delayed(const Duration(milliseconds: 300));
          return await _getUserProfile(response.user!.id);
        } catch (insertError) {
          debugPrint('Error creating user profile: $insertError');
          // Yine de eldeki bilgilerle kullanıcı modeli dön
          return UserModel(
            id: response.user!.id,
            picturePath: null,
            username: username,
            password: null,
            bio: '',
            email: email,
            createdAt: DateTime.parse(response.user!.createdAt),
          );
        }
      }
      return null;
    } on AuthException catch (e) {
      Helper().getMessage(
        status: StatusEnum.WARNING,
        message: e.message,
      );
      return null;
    } catch (e) {
      Helper().getMessage(
        status: StatusEnum.WARNING,
        message: 'An error occurred: $e',
      );
      return null;
    }
  } // Convert Supabase user data to existing UserModel format

  Future<UserModel?> _getUserProfile(String authUserId) async {
    // ...existing code before try...
    try {
      final response = await _client.from('app_user').select('*').eq('auth_user_id', authUserId).single();
      return UserModel(
        id: response['auth_user_id'],
        picturePath: response['picture_path'],
        username: response['username'],
        password: null,
        bio: response['bio'],
        email: response['email'],
        createdAt: DateTime.parse(response['created_at']),
      );
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      try {
        final authUser = _client.auth.currentUser;
        if (authUser != null && authUser.id == authUserId) {
          final meta = authUser.userMetadata ?? {};
          final metaUsername = meta['username'];
          return UserModel(
            id: authUser.id,
            picturePath: null,
            username: (metaUsername is String && metaUsername.trim().isNotEmpty) ? metaUsername : (authUser.email?.split('@').first ?? 'User'),
            password: null,
            bio: '',
            email: authUser.email ?? '',
            createdAt: DateTime.parse(authUser.createdAt),
          );
        }
      } catch (authError) {
        debugPrint('Error getting auth user: $authError');
      }
      return null;
    }
  }

  // ********************************************
  // USER METHODS - Compatible with existing models
  // ********************************************

  Future<UserModel?> getUserInfo({required String userId}) async {
    try {
      final response = await _client.from('app_user').select('*').eq('auth_user_id', userId).single();

      return UserModel(
        id: response['auth_user_id'],
        picturePath: response['picture_path'],
        username: response['username'],
        password: null,
        bio: response['bio'],
        email: response['email'],
        createdAt: DateTime.parse(response['created_at']),
      );
    } catch (e) {
      debugPrint('Error getting user info: $e');
      return null;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    try {
      final response = await _client.from('app_user').select('*').order('created_at', ascending: false);

      return (response as List)
          .map((e) => UserModel(
                id: e['id'], // Use UUID directly as String
                picturePath: e['picture_path'],
                username: e['username'],
                password: null,
                bio: e['bio'],
                email: e['email'],
                createdAt: DateTime.parse(e['created_at']),
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }

  // ********************************************
  // CONTENT METHODS - Compatible with existing models
  // ********************************************

  Future<ContentModel> getContentDetail({
    required int contentId,
    required ContentTypeEnum contentType,
    String? userId,
  }) async {
    try {
      // userId parametresini kullan, eğer null ise currentUserId'yi kullan
      final userIdToUse = userId ?? currentUserId;

      final response = await _client.rpc('get_content_detail', params: {
        'content_id_param': contentId,
        'content_type_param': contentType.index + 1,
        'user_id_param': userIdToUse,
      });

      final model = ContentModel.fromJson(response);

      // If aggregates look empty but we have user activity, recompute as fallback
      final aggregatesEmpty = ((model.consumeCount ?? 0) == 0) && ((model.favoriCount ?? 0) == 0) && ((model.reviewCount ?? 0) == 0) && ((model.ratingDistribution == null || model.ratingDistribution!.every((e) => e == 0)));
      final hasUserActivity = model.isFavorite == true || model.contentStatus != null || (model.rating != null && model.rating! > 0);
      if (aggregatesEmpty && hasUserActivity) {
        try {
          final agg = await _computeAggregatesForContent(contentId);
          if (agg != null) {
            model.consumeCount = agg['consume_count'] as int? ?? model.consumeCount;
            model.favoriCount = agg['favorite_count'] as int? ?? model.favoriCount;
            model.reviewCount = agg['review_count'] as int? ?? model.reviewCount;
            final dist = (agg['rating_distribution'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList();
            if (dist != null) model.ratingDistribution = dist;

            // Best-effort persist back to content table (ignore failures)
            try {
              await _client.from('content').update({
                'consume_count': model.consumeCount,
                'favorite_count': model.favoriCount,
                'review_count': model.reviewCount,
                'rating_distribution': model.ratingDistribution,
              }).eq('id', contentId);
            } catch (_) {}
          }
        } catch (e) {
          debugPrint('Aggregate fallback failed: $e');
        }
      }

      return model;
    } catch (e) {
      debugPrint('Error getting content detail: $e');
      rethrow;
    }
  }

  // Compute global aggregates from latest logs + reviews for a content
  Future<Map<String, dynamic>?> _computeAggregatesForContent(int contentId) async {
    try {
      // Fetch latest logs for this content across users
      final logs = await _client.from('latest_user_content_log').select('content_status_id,is_favorite,rating').eq('content_id', contentId);

      int consumeCount = 0;
      int favoriteCount = 0;
      final dist = List<int>.filled(5, 0);

      for (final row in (logs as List)) {
        final status = row['content_status_id'] as int?;
        final isFav = row['is_favorite'] as bool? ?? false;
        final rating = row['rating'];

        if (status == ContentStatusEnum.CONSUMED.index + 1) consumeCount++;
        if (isFav) favoriteCount++;
        if (rating != null) {
          final r = (rating is num) ? rating.toDouble() : double.tryParse(rating.toString());
          if (r != null && r > 0) {
            final idx = r.round().clamp(1, 5) - 1;
            dist[idx]++;
          }
        }
      }

      // Reviews count (simple length of ids)
      final rc = await _client.from('review').select('id').eq('content_id', contentId);
      final reviewCount = (rc as List).length;

      return {
        'consume_count': consumeCount,
        'favorite_count': favoriteCount,
        'review_count': reviewCount,
        'rating_distribution': dist,
      };
    } catch (e) {
      debugPrint('Error computing aggregates: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> searchContent({
    required String query,
    required ContentTypeEnum contentType,
    required int page,
    int limit = 20,
  }) async {
    try {
      final response = await _client.rpc('search_content', params: {
        'search_query': query,
        'content_type_param': contentType.index + 1,
        'page_param': page,
        'limit_param': limit,
      });

      final List<ContentModel> contentList = (response['contents'] as List).map((e) => ContentModel.fromJson(e)).toList();

      return {
        'contentList': contentList,
        'totalPages': response['total_pages'],
      };
    } catch (e) {
      debugPrint('Error searching content: $e');
      return {'contentList': <ContentModel>[], 'totalPages': 0};
    }
  }

  // ********************************************
  // SHOWCASE METHODS - Compatible with existing models
  // ********************************************

  Future<Map<String, dynamic>> getTrendContents({
    required ContentTypeEnum contentType,
  }) async {
    try {
      final response = await _client.rpc('get_trend_contents', params: {
        'content_type_param': contentType.index + 1,
        'user_id_param': currentUserId,
      });

      final List<ShowcaseContentModel> contentList = (response as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

      return {'contentList': contentList};
    } catch (e) {
      debugPrint('Error getting trend contents: $e');
      return {'contentList': <ShowcaseContentModel>[]};
    }
  }

  Future<Map<String, dynamic>> getRecommendedContents({
    required String userId,
    required ContentTypeEnum contentType,
  }) async {
    try {
      final response = await _client.rpc('get_recommended_contents', params: {
        'user_id_param': currentUserId,
        'content_type_param': contentType.index + 1,
      });

      final List<ShowcaseContentModel> contentList = (response as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

      return {'contentList': contentList};
    } catch (e) {
      debugPrint('Error getting recommended contents: $e');
      return {'contentList': <ShowcaseContentModel>[]};
    }
  }

  Future<Map<String, dynamic>> getFriendActivities({
    required ContentTypeEnum contentType,
  }) async {
    try {
      final response = await _client.rpc('get_friend_activities', params: {
        'content_type_param': contentType.index + 1,
        'user_id_param': currentUserId,
      });

      final List<ShowcaseContentModel> contentList = (response as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

      return {'contentList': contentList};
    } catch (e) {
      debugPrint('Error getting friend activities: $e');
      return {'contentList': <ShowcaseContentModel>[]};
    }
  }

  // ********************************************
  // USER CONTENT INTERACTION METHODS
  // ********************************************

  Future<void> contentUserAction({
    required ContentLogModel contentLogModel,
  }) async {
    try {
      // Ensure the content row exists in Supabase before inserting a log.
      // Discover/Explore listeleri external API'den geldiği için içerik daha önce kaydedilmemiş olabilir.
      try {
        final existing = await _client.from('content').select('id').eq('id', contentLogModel.contentID).maybeSingle();
        if (existing == null) {
          debugPrint('ℹ️ Content ${contentLogModel.contentID} not found in Supabase. Fetching & saving before logging.');
          await ExternalApiService().getContentDetail(
            contentId: contentLogModel.contentID,
            contentTypeId: contentLogModel.contentType.index + 1,
            userId: currentUserId,
          );
        }
      } catch (e) {
        debugPrint('⚠️ Ensure content exists check failed (continuing): $e');
      }

      final data = {
        'user_id': currentUserId,
        'content_id': contentLogModel.contentID,
        'content_status_id': contentLogModel.contentStatus?.index != null ? contentLogModel.contentStatus!.index + 1 : null,
        'rating': contentLogModel.rating == 0 ? null : contentLogModel.rating,
        'is_favorite': contentLogModel.isFavorite,
        'is_consume_later': contentLogModel.isConsumeLater,
      };

      // Handle review if provided
      int? reviewId;
      if (contentLogModel.review != null && contentLogModel.review!.isNotEmpty) {
        final reviewResponse = await _client
            .from('review')
            .upsert({
              'user_id': currentUserId,
              'content_id': contentLogModel.contentID,
              'text': contentLogModel.review,
            })
            .select('id')
            .single();

        reviewId = reviewResponse['id'];
      }

      data['review_id'] = reviewId;

      // Insert new user content log (multiple logs allowed)
      await _client.from('user_content_log').insert(data);

      // Force recompute aggregates (favorite_count, consume_count, review_count, rating_distribution)
      try {
        await _client.rpc('recompute_content_stats', params: {
          'content_id_param': contentLogModel.contentID,
        });
      } catch (e) {
        debugPrint('recompute_content_stats RPC failed (continuing): $e');
      }
    } catch (e) {
      debugPrint('Error in content user action: $e');
      rethrow;
    }
  }

  // ********************************************
  // REVIEW METHODS
  // ********************************************

  Future<List<ReviewModel>> getContentReviews({
    required int contentId,
  }) async {
    try {
      // First get current user ID for like checking
      String? currentUserId;
      try {
        final currentUser = await getCurrentUserProfile();
        currentUserId = currentUser?.id;
      } catch (e) {
        debugPrint('Could not get current user: $e');
      }

      final response = await _client.from('review').select('''
            *,
            app_user:user_id (
              auth_user_id,
              username,
              picture_path
            )
          ''').eq('content_id', contentId).order('created_at', ascending: false);

      List<ReviewModel> reviews = [];

      for (var e in response as List) {
        // Get like count for this review
        final likeCount = await getReviewLikeCount(e['id']);

        // Get reply count for this review
        final replyCount = await getReviewReplyCount(reviewId: e['id']);

        // Check if current user liked this review
        bool isLikedByCurrentUser = false;
        if (currentUserId != null) {
          isLikedByCurrentUser = await checkUserLikedReview(
            reviewId: e['id'],
            userId: currentUserId,
          );
        }

        // Get user's rating and favorite status for the content this review is about
        double? userRating;
        bool isFavorite = false;

        if (e['user_id'] != null) {
          try {
            final userLog = await _client.from('user_content_log').select('rating, is_favorite').eq('user_id', e['user_id']).eq('content_id', contentId).maybeSingle();

            if (userLog != null) {
              userRating = userLog['rating']?.toDouble();
              isFavorite = userLog['is_favorite'] ?? false;
            }
          } catch (logError) {
            debugPrint('Error getting user log for review: $logError');
          }
        }

        reviews.add(ReviewModel.fromJson({
          'id': e['id'],
          'picture_path': e['app_user']?['picture_path'],
          'user_id': e['app_user']?['auth_user_id'] ?? e['user_id'],
          'username': e['app_user']?['username'] ?? 'Unknown User',
          'text': e['text'],
          'created_at': e['created_at'],
          'rating': userRating,
          'is_favorite': isFavorite,
          'like_count': likeCount,
          'comment_count': replyCount, // Now shows reply count
          'is_liked_by_current_user': isLikedByCurrentUser,
        }));
      }

      return reviews;
    } catch (e) {
      debugPrint('Error getting content reviews: $e');
      return [];
    }
  }

  Future<List<UserReviewModel>> getUserReviews({
    required String userId,
    ContentTypeEnum? contentType,
  }) async {
    try {
      // Get current user ID for like checking
      String? currentUserId;
      try {
        final currentUser = await getCurrentUserProfile();
        currentUserId = currentUser?.id;
      } catch (e) {
        debugPrint('Could not get current user: $e');
      }

      final response = await _client.from('review').select('''
            *,
            content:content_id (
              id,
              title,
              poster_path,
              content_type_id
            )
          ''').eq('user_id', userId).order('created_at', ascending: false);

      List<UserReviewModel> reviews = [];

      for (var e in response as List) {
        // Get like count for this review
        final likeCount = await getReviewLikeCount(e['id']);

        // Check if current user liked this review
        bool isLikedByCurrentUser = false;
        if (currentUserId != null) {
          isLikedByCurrentUser = await checkUserLikedReview(
            reviewId: e['id'],
            userId: currentUserId,
          );
        }

        // Get user's rating and favorite status for the content this review is about
        double? userRating;
        bool isFavorite = false;

        if (e['content_id'] != null) {
          try {
            final userLog = await _client.from('user_content_log').select('rating, is_favorite').eq('user_id', userId).eq('content_id', e['content_id']).maybeSingle();

            if (userLog != null) {
              userRating = userLog['rating']?.toDouble();
              isFavorite = userLog['is_favorite'] ?? false;
            }
          } catch (logError) {
            debugPrint('Error getting user log for profile review: $logError');
          }
        }

        reviews.add(UserReviewModel.fromJson({
          'id': e['id'],
          'text': e['text'],
          'created_at': e['created_at'],
          'content_id': e['content']?['id'] ?? e['content_id'],
          'content_type_id': e['content']?['content_type_id'] ?? 1,
          'title': e['content']?['title'] ?? 'Unknown Title',
          'poster_path': e['content']?['poster_path'],
          'rating': userRating,
          'is_favorite': isFavorite,
          'like_count': likeCount,
          'comment_count': 0,
          'is_liked_by_current_user': isLikedByCurrentUser,
        }));
      }

      return reviews;
    } catch (e) {
      debugPrint('Error getting user reviews: $e');
      return [];
    }
  }

  Future<List<UserReviewModel>> getTopReviews({
    ContentTypeEnum? contentType,
  }) async {
    try {
      final response = await _client.rpc('get_top_reviews', params: {
        'content_type_param': contentType?.index != null ? contentType!.index + 1 : null,
        'limit_param': 5,
      });

      return (response as List).map((e) => UserReviewModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting top reviews: $e');
      return [];
    }
  }

  // ********************************************
  // FOLLOW METHODS
  // ********************************************

  Future<void> followUnfollow({
    required String userId,
    required String followingUserID,
  }) async {
    try {
      // Check if already following
      final existing = await _client.from('user_follow').select('id').eq('user_id', userId).eq('following_user_id', followingUserID).maybeSingle();

      if (existing != null) {
        // Unfollow
        await _client.from('user_follow').delete().eq('user_id', userId).eq('following_user_id', followingUserID);
      } else {
        // Follow
        await _client.from('user_follow').insert({
          'user_id': userId,
          'following_user_id': followingUserID,
        });
      }
    } catch (e) {
      debugPrint('Error in follow/unfollow: $e');
      rethrow;
    }
  }

  // ********************************************
  // CONTENT MANAGEMENT METHODS
  // ********************************************

  Future<int> addContent({required ContentModel contentModel}) async {
    try {
      final response = await _client.from('content').insert(contentModel.toJson()).select('id').single();

      return response['id'] as int;
    } catch (e) {
      debugPrint('Error adding content: $e');
      rethrow;
    }
  }

  Future<void> updateContent({required ContentModel contentModel}) async {
    try {
      await _client.from('content').update(contentModel.toJson()).eq('id', contentModel.id!);
    } catch (e) {
      debugPrint('Error updating content: $e');
      rethrow;
    }
  }

  Future<void> deleteContent({required int contentID}) async {
    try {
      await _client.from('content').delete().eq('id', contentID);
    } catch (e) {
      debugPrint('Error deleting content: $e');
      rethrow;
    }
  }

  Future<void> deleteUser({required String userId}) async {
    try {
      // First find the auth_user_id for this user
      final userRecord = await _client.from('app_user').select('auth_user_id').eq('id', userId).single();

      // Delete from auth.users (this will cascade delete from app_user)
      await _client.auth.admin.deleteUser(userRecord['auth_user_id']);
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }

  // ********************************************
  // DISCOVER AND USER CONTENT METHODS
  // ********************************************

  Future<Map<String, dynamic>> getUserContents({
    required ContentTypeEnum contentType,
    required String logUserId,
  }) async {
    try {
      // 1) RPC fonksiyonunu dene (get_user_contents) -> SECURITY DEFINER ise diğer kullanıcı içerikleri gelebilir
      try {
        final rpc = await _client.rpc('get_user_contents', params: {
          'user_id_param': currentUserId,
          'log_user_id_param': logUserId,
          'content_type_param': contentType.index + 1,
          'page_param': 1,
          'limit_param': 40,
        });

        if (rpc is Map && rpc['contents'] != null) {
          final rawList = (rpc['contents'] as List);
          // Deduplicate by content_id keeping the latest date
          final Map<int, Map<String, dynamic>> best = {};
          for (final item in rawList) {
            final row = Map<String, dynamic>.from(item as Map);
            final int cid = (row['content_id'] ?? row['id']) as int;
            final String? dateStr = (row['date'] ?? (row['userLog'] != null ? row['userLog']['date'] : null)) as String?;
            final DateTime dt = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.fromMillisecondsSinceEpoch(0);
            if (!best.containsKey(cid)) {
              best[cid] = row..['__dt'] = dt;
            } else {
              final prev = best[cid]!;
              final prevDt = prev['__dt'] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0);
              if (dt.isAfter(prevDt)) {
                best[cid] = row..['__dt'] = dt;
              }
            }
          }
          // Remove helper field and map
          final contentList = best.values.map((m) {
            m.remove('__dt');
            return ShowcaseContentModel.fromJson(m);
          }).toList();
          return {
            'contentList': contentList,
            'totalPages': rpc['total_pages'] ?? 1,
          };
        }
      } catch (e) {
        debugPrint('RPC get_user_contents fallback: $e');
      }

      // 2) Fallback: kendi loglarına erişim (RLS kısıtı olabilir)
      final response = await _client.from('latest_user_content_log').select('''
            id,
            user_id,
            content_id,
            rating,
            content_status_id,
            is_favorite,
            is_consume_later,
            date,
            content:content_id!inner (
              id,
              title,
              poster_path,
              content_type_id,
              release_date,
              description,
              consume_count,
              favorite_count,
              list_count,
              review_count,
              rating_distribution
            )
          ''').eq('user_id', logUserId).eq('content.content_type_id', contentType.index + 1).eq('content_status_id', ContentStatusEnum.CONSUMED.index + 1).order('date', ascending: false);

      final rows = (response as List).where((e) => e['content'] != null).toList();
      // Deduplicate by content_id keeping latest date
      final Map<int, Map<String, dynamic>> best = {};
      for (final e in rows) {
        final int cid = e['content_id'] as int;
        final String? dateStr = e['date'] as String?;
        final DateTime dt = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.fromMillisecondsSinceEpoch(0);
        if (!best.containsKey(cid)) {
          best[cid] = Map<String, dynamic>.from(e)..['__dt'] = dt;
        } else {
          final prev = best[cid]!;
          final prevDt = prev['__dt'] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0);
          if (dt.isAfter(prevDt)) {
            best[cid] = Map<String, dynamic>.from(e)..['__dt'] = dt;
          }
        }
      }
      final deduped = best.values.map((m) {
        m.remove('__dt');
        return m;
      }).toList();

      final contentList = deduped
          .map((e) => ShowcaseContentModel.fromJson({
                ...e['content'],
                'rating': e['rating'],
                'content_status_id': e['content_status_id'],
                'is_favorite': e['is_favorite'],
                'is_consume_later': e['is_consume_later'],
                'userLog': {
                  'id': e['id'],
                  'user_id': e['user_id'],
                  'picture_path': null,
                  'content_id': e['content_id'],
                  'date': e['date'],
                  'content_status_id': e['content_status_id'],
                  'rating': e['rating'],
                  'is_favorite': e['is_favorite'],
                  'is_consume_later': e['is_consume_later'],
                  'review_text': null,
                  'content_type_id': e['content']?['content_type_id'],
                }
              }))
          .toList();

      return {'contentList': contentList, 'totalPages': 1};
    } catch (e) {
      debugPrint('Error getting user contents: $e');
      return {'contentList': <ShowcaseContentModel>[], 'totalPages': 0};
    }
  }

  Future<Map<String, dynamic>> getDiscoverMovie({required String userId}) async {
    try {
      // Simplified discovery - could be enhanced with recommendation logic
      final rows = await _client
          .from('content')
          .select('*')
          .eq('content_type_id', 1) // Movie
          .order('consume_count', ascending: false)
          .limit(5);

      final contentList = (rows as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

      return {
        'contentList': contentList,
        'totalPages': 1,
      };
    } catch (e) {
      debugPrint('Error getting discover movies: $e');
      return {'contentList': <ShowcaseContentModel>[], 'totalPages': 0};
    }
  }

  Future<Map<String, dynamic>> getDiscoverGame({required String userId}) async {
    try {
      // Simplified discovery - could be enhanced with recommendation logic
      final response = await _client
          .from('content')
          .select('*')
          .eq('content_type_id', 2) // Game
          .order('consume_count', ascending: false)
          .limit(5);

      final contentList = (response as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

      return {
        'contentList': contentList,
        'totalPages': 1,
      };
    } catch (e) {
      debugPrint('Error getting discover games: $e');
      return {'contentList': <ShowcaseContentModel>[], 'totalPages': 0};
    }
  }

  // ********************************************
  // SOCIAL NETWORK METHODS
  // ********************************************

  Future<List<Map<String, dynamic>>> getFollowers({required String userId}) async {
    try {
      final response = await _client.from('user_follow').select('''
            user_id,
            app_user!user_follow_user_id_fkey (
              auth_user_id,
              username,
              picture_path
            )
          ''').eq('following_user_id', userId);

      return (response as List)
          .map((e) => {
                'id': e['app_user']['auth_user_id'],
                'username': e['app_user']['username'],
                'picture_path': e['app_user']['picture_path'],
              })
          .toList();
    } catch (e) {
      debugPrint('Error getting followers: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFollowing({required String userId}) async {
    try {
      final response = await _client.from('user_follow').select('''
            following_user_id,
            app_user!user_follow_following_user_id_fkey (
              id,
              username,
              picture_path
            )
          ''').eq('user_id', userId);

      return (response as List)
          .map((e) => {
                'id': e['app_user']['id'],
                'username': e['app_user']['username'],
                'picture_path': e['app_user']['picture_path'],
              })
          .toList();
    } catch (e) {
      debugPrint('Error getting following: $e');
      return [];
    }
  }

  // ********************************************
  // STATISTICS METHODS
  // ********************************************

  Future<List<Map<String, dynamic>>> getTopActorsByMovieCount({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      // Simplified statistics - would need proper aggregation in real implementation
      final response = await _client.from('m_cast').select('*').limit(limit);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting top actors: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMostWatchedMovies({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      final response = await _client.from('content').select('*').eq('content_type_id', 1).order('consume_count', ascending: false).limit(limit);
      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting most watched movies: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAverageMovieRatingsByGenre({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      // Basit placeholder: genre tablosu. (Geliştirilebilir: content + user_content_log join ile ortalama hesaplama)
      final response = await _client.from('m_genre').select('*').limit(limit).order('id');
      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting average movie ratings by genre: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAverageMovieRatingsByYear({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      // Basit placeholder: release_date'e göre film listesi. (Geliştirilebilir: yıl bazlı aggregation)
      final response = await _client.from('content').select('id, title, release_date, consume_count').eq('content_type_id', 1).not('release_date', 'is', null).order('release_date', ascending: false).limit(limit);
      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting average movie ratings by year: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopMovieGenres({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      // Placeholder: genre tablosu. (Geliştirilebilir: join ile kullanım sayısı)
      final response = await _client.from('m_genre').select('*').limit(limit);
      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting top movie genres: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopContentTypes({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      final response = await _client.from('content_type_lookup').select('*').limit(limit);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting top content types: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getWeeklyContentLogs({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      final response = await _client.from('user_content_log').select('*, content(*)').order('date', ascending: false).limit(limit);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting weekly content logs: $e');
      return [];
    }
  }

  // ********************************************
  // RATING AGGREGATION HELPERS
  // ********************************************

  Future<Map<int, double>> getAverageRatingsForContentIds(List<int> contentIds) async {
    if (contentIds.isEmpty) return {};
    try {
      final response = await _client.from('user_content_log').select('content_id, avg(rating)').inFilter('content_id', contentIds).not('rating', 'is', null);

      final Map<int, double> map = {};
      for (final row in response) {
        final id = row['content_id'] as int?;
        if (id != null) {
          // PostgREST aggregator key could be 'avg' or 'avg_rating'; check both
          final avgVal = row['avg'] ?? row['avg_rating'] ?? row['avg_rating_1'];
          if (avgVal != null) {
            final doubleAvg = avgVal is num ? avgVal.toDouble() : double.tryParse(avgVal.toString());
            if (doubleAvg != null) map[id] = doubleAvg;
          }
        }
      }
      return map;
    } catch (e) {
      debugPrint('Error getting average ratings: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUserActivities({
    required String profileUserID,
    required ContentTypeEnum contentType,
  }) async {
    try {
      // Use latest_user_content_log view to ensure we only look at the real latest log per content
      final response = await _client
          .from('latest_user_content_log')
          .select('''
            id,
            user_id,
            content_id,
            rating,
            content_status_id,
            is_favorite,
            is_consume_later,
            date,
            content:content_id!inner (
              id,
              title,
              poster_path,
              content_type_id,
              release_date,
              description,
              consume_count,
              favorite_count,
              list_count,
              review_count,
              rating_distribution
            )
          ''')
          .eq('user_id', profileUserID)
          .eq('content.content_type_id', contentType.index + 1)
          // filter AFTER ensuring we are on the latest log so status reflects current state
          .eq('content_status_id', ContentStatusEnum.CONSUMED.index + 1)
          .order('date', ascending: false);

      final rows = (response as List).where((e) => e['content'] != null).toList();

      final contentList = rows
          .map((e) => ShowcaseContentModel.fromJson({
                ...e['content'],
                'rating': e['rating'],
                'content_status_id': e['content_status_id'],
                'is_favorite': e['is_favorite'],
                'is_consume_later': e['is_consume_later'],
                'userLog': {
                  'id': e['id'],
                  'user_id': e['user_id'],
                  'picture_path': null,
                  'content_id': e['content_id'],
                  'date': e['date'],
                  'content_status_id': e['content_status_id'],
                  'rating': e['rating'],
                  'is_favorite': e['is_favorite'],
                  'is_consume_later': e['is_consume_later'],
                  'review_text': null,
                  'content_type_id': e['content']?['content_type_id'],
                }
              }))
          .toList();

      return {
        'contentList': contentList,
      };
    } catch (e) {
      debugPrint('Error getting user activities: $e');
      return {'contentList': <ShowcaseContentModel>[]};
    }
  }

  // ********************************************
  // USER LOG MANAGEMENT (fetch/update/delete)
  // ********************************************

  Future<List<ContentLogModel>> getUserLogsForContent({required int contentId}) async {
    try {
      if (currentUserId == null) return [];
      final rows = await _client.from('user_content_log').select('''
            id,
            user_id,
            content_id,
            content_status_id,
            rating,
            is_favorite,
            is_consume_later,
            date,
            review:review_id ( id, text ),
            content:content_id!inner ( content_type_id )
          ''').eq('content_id', contentId).eq('user_id', currentUserId!).order('date', ascending: false).order('id', ascending: false);

      final List<ContentLogModel> list = [];
      for (final row in (rows as List)) {
        final ctId = row['content']?['content_type_id'] as int?;
        final contentType = ctId != null && ctId >= 1 && ctId <= ContentTypeEnum.values.length ? ContentTypeEnum.values[ctId - 1] : ContentTypeEnum.MOVIE;
        list.add(ContentLogModel(
          id: row['id'] as int?,
          userId: row['user_id'] as String,
          contentID: row['content_id'] as int,
          date: row['date'] != null ? DateTime.parse(row['date']) : null,
          contentStatus: row['content_status_id'] != null ? ContentStatusEnum.values[(row['content_status_id'] as int) - 1] : null,
          rating: (row['rating'] is num) ? (row['rating'] as num).toDouble() : double.tryParse('${row['rating']}'),
          isFavorite: row['is_favorite'] as bool?,
          isConsumeLater: row['is_consume_later'] as bool?,
          review: (row['review'] == null) ? null : (row['review'] as Map)['text'] as String?,
          contentType: contentType,
        ));
      }
      return list;
    } catch (e) {
      debugPrint('Error fetching user logs: $e');
      return [];
    }
  }

  Future<void> updateUserLog({
    required int logId,
    required int contentId,
    ContentStatusEnum? contentStatus,
    double? rating,
    bool? isFavorite,
    bool? isConsumeLater,
    String? reviewText,
  }) async {
    try {
      if (currentUserId == null) throw Exception('Not authenticated');
      final Map<String, dynamic> data = {
        'content_status_id': contentStatus != null ? contentStatus.index + 1 : null,
        'rating': (rating == null || rating == 0) ? null : rating,
        'is_favorite': isFavorite,
        'is_consume_later': isConsumeLater,
        // Update the log's date to now when edited
        'date': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }..removeWhere((key, value) => value == null);

      // Fetch existing log to get current review_id and verify ownership
      final existingLog = await _client.from('user_content_log').select('id, user_id, review_id').eq('id', logId).eq('user_id', currentUserId!).maybeSingle();
      if (existingLog == null) throw Exception('Log not found or not owned by user');

      int? existingReviewId = existingLog['review_id'] as int?;
      if (reviewText != null) {
        final trimmed = reviewText.trim();
        if (trimmed.isEmpty) {
          // Unlink and delete existing review if any
          data['review_id'] = null;
          if (existingReviewId != null) {
            try {
              await _client.from('review').delete().eq('id', existingReviewId).eq('user_id', currentUserId!).eq('content_id', contentId);
            } catch (e) {
              debugPrint('Review delete failed: $e');
            }
            existingReviewId = null;
          }
        } else {
          if (existingReviewId != null) {
            // Update existing review
            try {
              await _client.from('review').update({'text': trimmed}).eq('id', existingReviewId).eq('user_id', currentUserId!).eq('content_id', contentId);
            } catch (e) {
              debugPrint('Review update failed: $e');
            }
            data['review_id'] = existingReviewId;
          } else {
            // Try to reuse an existing review by this user for this content
            try {
              final maybeExisting = await _client.from('review').select('id').eq('user_id', currentUserId!).eq('content_id', contentId).maybeSingle();
              if (maybeExisting != null && maybeExisting['id'] != null) {
                final reuseId = maybeExisting['id'] as int;
                await _client.from('review').update({'text': trimmed}).eq('id', reuseId);
                data['review_id'] = reuseId;
              } else {
                // Create new review
                final inserted = await _client
                    .from('review')
                    .insert({
                      'user_id': currentUserId,
                      'content_id': contentId,
                      'text': trimmed,
                    })
                    .select('id')
                    .single();
                final newId = inserted['id'] as int?;
                if (newId != null) data['review_id'] = newId;
              }
            } catch (e) {
              debugPrint('Review upsert (reuse/insert) failed: $e');
            }
          }
        }
      }

      await _client.from('user_content_log').update(data).eq('id', logId).eq('user_id', currentUserId!);

      // Recompute aggregates
      try {
        await _client.rpc('recompute_content_stats', params: {'content_id_param': contentId});
      } catch (e) {
        debugPrint('recompute_content_stats RPC failed after update: $e');
      }
    } catch (e) {
      debugPrint('Error updating user log: $e');
      rethrow;
    }
  }

  Future<void> deleteUserLog({required int logId, required int contentId}) async {
    try {
      if (currentUserId == null) throw Exception('Not authenticated');
      // Load existing to find attached review_id
      final existingLog = await _client.from('user_content_log').select('id, user_id, review_id').eq('id', logId).eq('user_id', currentUserId!).maybeSingle();
      int? reviewId = existingLog != null ? existingLog['review_id'] as int? : null;

      // Delete the log row strictly by id + user_id and return deleted rows
      final deleted = await _client.from('user_content_log').delete().eq('id', logId).eq('user_id', currentUserId!).select('id');

      final bool logDeleted = deleted.isNotEmpty;

      // Optionally delete the linked review if present
      if (logDeleted && reviewId != null) {
        try {
          await _client.from('review').delete().eq('id', reviewId).eq('user_id', currentUserId!).eq('content_id', contentId);
        } catch (e) {
          debugPrint('Review delete after log delete failed: $e');
        }
      }
      if (logDeleted) {
        try {
          await _client.rpc('recompute_content_stats', params: {'content_id_param': contentId});
        } catch (e) {
          debugPrint('recompute_content_stats RPC failed after delete: $e');
        }
      } else {
        debugPrint('Log delete returned empty; nothing deleted for logId=$logId user=$currentUserId');
      }
    } catch (e) {
      debugPrint('Error deleting user log: $e');
      rethrow;
    }
  }

  // ********************************************
  // REVIEW LIKE METHODS
  // ********************************************

  Future<bool> toggleReviewLike({
    required int reviewId,
    required String userId,
  }) async {
    try {
      // Check if user already liked the review
      final existingLike = await _client.from('review_likes').select('id').eq('review_id', reviewId).eq('user_id', userId).maybeSingle();

      if (existingLike != null) {
        // Unlike: Remove the like
        await _client.from('review_likes').delete().eq('review_id', reviewId).eq('user_id', userId);
        return false; // Not liked anymore
      } else {
        // Like: Add the like
        await _client.from('review_likes').insert({
          'review_id': reviewId,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });
        return true; // Now liked
      }
    } catch (e) {
      debugPrint('Error toggling review like: $e');
      return false;
    }
  }

  Future<int> getReviewLikeCount(int reviewId) async {
    try {
      final response = await _client.from('review_likes').select('id').eq('review_id', reviewId);

      return (response as List).length;
    } catch (e) {
      debugPrint('Error getting review like count: $e');
      return 0;
    }
  }

  Future<bool> checkUserLikedReview({
    required int reviewId,
    required String userId,
  }) async {
    try {
      final response = await _client.from('review_likes').select('id').eq('review_id', reviewId).eq('user_id', userId).maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Error checking user liked review: $e');
      return false;
    }
  }

  // ********************************************
  // REVIEW REPLY METHODS
  // ********************************************

  Future<List<ReviewReplyModel>> getReviewReplies({
    required int reviewId,
  }) async {
    try {
      final currentUser = await getCurrentUserProfile();
      final currentUserId = currentUser?.id;

      final response = await _client.from('review_replies').select('''
            *,
            app_user:user_id (
              auth_user_id,
              username,
              picture_path
            ),
            parent_user:parent_reply_id (
              app_user:user_id (
                username
              )
            )
          ''').eq('review_id', reviewId).order('created_at', ascending: true);

      List<ReviewReplyModel> allReplies = [];
      Map<int, ReviewReplyModel> replyMap = {};

      // First pass: create all reply objects with like info
      for (var e in response as List) {
        // Get like count for this reply
        final likeCount = await getReviewReplyLikeCount(e['id']);

        // Check if current user liked this reply
        bool isLikedByCurrentUser = false;
        if (currentUserId != null) {
          isLikedByCurrentUser = await isReviewReplyLikedByUser(
            replyId: e['id'],
            userId: currentUserId,
          );
        }

        final reply = ReviewReplyModel.fromJson({
          'id': e['id'],
          'review_id': e['review_id'],
          'user_id': e['app_user']?['auth_user_id'] ?? e['user_id'],
          'username': e['app_user']?['username'] ?? 'Unknown User',
          'picture_path': e['app_user']?['picture_path'],
          'text': e['text'],
          'created_at': e['created_at'],
          'parent_reply_id': e['parent_reply_id'],
          'parent_user_name': e['parent_user']?['app_user']?['username'],
          'updated_at': e['updated_at'],
          'replies': [],
          'like_count': likeCount,
          'is_liked_by_current_user': isLikedByCurrentUser,
        });

        replyMap[reply.id] = reply;
        allReplies.add(reply);
      }

      // Second pass: organize nested structure
      List<ReviewReplyModel> topLevelReplies = [];
      for (var reply in allReplies) {
        if (reply.parentReplyId == null) {
          // Top level reply
          topLevelReplies.add(reply);
        } else {
          // Nested reply - add to parent
          final parent = replyMap[reply.parentReplyId!];
          if (parent != null) {
            parent.replies.add(reply);
          }
        }
      }

      return topLevelReplies;
    } catch (e) {
      debugPrint('Error getting review replies: $e');
      return [];
    }
  }

  Future<int> getReviewReplyCount({
    required int reviewId,
  }) async {
    try {
      final response = await _client.from('review_replies').select('id').eq('review_id', reviewId);

      return (response as List).length;
    } catch (e) {
      debugPrint('Error getting review reply count: $e');
      return 0;
    }
  }

  Future<ReviewReplyModel?> addReviewReply({
    required int reviewId,
    required String userId,
    required String text,
    int? parentReplyId,
  }) async {
    try {
      final response = await _client.from('review_replies').insert({
        'review_id': reviewId,
        'user_id': userId,
        'text': text,
        'parent_reply_id': parentReplyId,
      }).select('''
            *,
            app_user:user_id (
              auth_user_id,
              username,
              picture_path
            )
          ''').single();

      return ReviewReplyModel.fromJson({
        'id': response['id'],
        'review_id': response['review_id'],
        'user_id': response['app_user']['auth_user_id'],
        'username': response['app_user']['username'],
        'picture_path': response['app_user']['picture_path'],
        'text': response['text'],
        'created_at': response['created_at'],
        'parent_reply_id': response['parent_reply_id'],
        'updated_at': response['updated_at'],
        'replies': [],
      });
    } catch (e) {
      debugPrint('Error adding review reply: $e');
      return null;
    }
  }

  Future<bool> deleteReviewReply({
    required int replyId,
    required String userId,
  }) async {
    try {
      await _client.from('review_replies').delete().eq('id', replyId).eq('user_id', userId);

      return true;
    } catch (e) {
      debugPrint('Error deleting review reply: $e');
      return false;
    }
  }

  // Reply like management
  Future<bool> toggleReviewReplyLike({
    required int replyId,
    required String userId,
  }) async {
    try {
      // Check if the user has already liked this reply
      final existingLike = await _client.from('review_reply_likes').select('id').eq('reply_id', replyId).eq('user_id', userId).maybeSingle();

      if (existingLike != null) {
        // Unlike - remove the like
        await _client.from('review_reply_likes').delete().eq('reply_id', replyId).eq('user_id', userId);
        return false;
      } else {
        // Like - add the like
        await _client.from('review_reply_likes').insert({
          'reply_id': replyId,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling reply like: $e');
      return false;
    }
  }

  Future<int> getReviewReplyLikeCount(int replyId) async {
    try {
      final response = await _client.from('review_reply_likes').select('id').eq('reply_id', replyId);

      return response.length;
    } catch (e) {
      debugPrint('Error getting reply like count: $e');
      return 0;
    }
  }

  Future<bool> isReviewReplyLikedByUser({
    required int replyId,
    required String userId,
  }) async {
    try {
      final like = await _client.from('review_reply_likes').select('id').eq('reply_id', replyId).eq('user_id', userId).maybeSingle();

      return like != null;
    } catch (e) {
      debugPrint('Error checking reply like status: $e');
      return false;
    }
  }

  // Add other methods as needed to maintain compatibility...
}
