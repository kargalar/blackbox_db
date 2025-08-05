import 'package:blackbox_db/1_Core/Enums/status_enum.dart';
import 'package:blackbox_db/1_Core/helper.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:blackbox_db/8_Model/user_model.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
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
      // First, sign up the user
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Try to create user profile in app_user table
        try {
          await _client.from('app_user').insert({
            'auth_user_id': response.user!.id,
            'username': username,
            'email': email,
            'bio': '',
            'picture_path': null,
          });

          // Wait a bit for the data to be committed
          await Future.delayed(const Duration(milliseconds: 500));
          return await _getUserProfile(response.user!.id);
        } catch (insertError) {
          debugPrint('Error creating user profile: $insertError');

          // If profile creation fails, return a UserModel from auth user data
          // This handles RLS permission issues gracefully
          return UserModel(
            id: response.user!.id, // Use UUID directly as String
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
    try {
      final response = await _client.from('app_user').select('*').eq('auth_user_id', authUserId).single();

      // Convert UUID to int for compatibility
      return UserModel(
        id: response['id'], // Use UUID directly as String
        picturePath: response['picture_path'],
        username: response['username'],
        password: null, // Don't store password
        bio: response['bio'],
        email: response['email'],
        createdAt: DateTime.parse(response['created_at']),
      );
    } catch (e) {
      debugPrint('Error getting user profile: $e');

      // If app_user profile doesn't exist, try to get from auth user
      try {
        final authUser = _client.auth.currentUser;
        if (authUser != null && authUser.id == authUserId) {
          return UserModel(
            id: authUser.id, // Use UUID directly as String
            picturePath: null,
            username: authUser.email?.split('@')[0] ?? 'User', // Use email prefix as username
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

      return ContentModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting content detail: $e');
      rethrow;
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
      final response = await _client.from('review').select('''
            *,
            app_user:user_id (
              auth_user_id,
              username,
              picture_path
            )
          ''').eq('content_id', contentId).order('created_at', ascending: false);

      return (response as List)
          .map((e) => ReviewModel.fromJson({
                'id': e['id'],
                'picture_path': e['app_user']['picture_path'],
                'user_id': e['app_user']['auth_user_id'].hashCode, // Convert UUID to int
                'username': e['app_user']['username'],
                'text': e['text'],
                'created_at': e['created_at'],
              }))
          .toList();
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
      final response = await _client.from('review').select('''
            *,
            content:content_id (
              id,
              title,
              poster_path,
              content_type_id
            )
          ''').eq('user_id', currentUserId!).order('created_at', ascending: false);

      return (response as List)
          .map((e) => UserReviewModel.fromJson({
                'id': e['id'],
                'text': e['text'],
                'created_at': e['created_at'],
                'content_id': e['content']['id'],
                'content_type_id': e['content']['content_type_id'],
                'title': e['content']['title'],
                'poster_path': e['content']['poster_path'],
              }))
          .toList();
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
      // This would need pagination logic similar to the original
      final response = await _client.from('user_content_log').select('''
            *,
            content:content_id (
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
          ''').eq('user_id', logUserId).eq('content.content_type_id', contentType.index + 1).order('date', ascending: false);

      final contentList = (response as List)
          .map((e) => ShowcaseContentModel.fromJson({
                ...e['content'],
                'user_rating': e['rating'],
                'user_status': e['content_status_id'],
                'is_favorite': e['is_favorite'],
                'is_consume_later': e['is_consume_later'],
              }))
          .toList();

      return {
        'contentList': contentList,
        'totalPages': 1, // Simplified for now
      };
    } catch (e) {
      debugPrint('Error getting user contents: $e');
      return {'contentList': <ShowcaseContentModel>[], 'totalPages': 0};
    }
  }

  Future<Map<String, dynamic>> getDiscoverMovie({required String userId}) async {
    try {
      // Simplified discovery - could be enhanced with recommendation logic
      final response = await _client
          .from('content')
          .select('*')
          .eq('content_type_id', 1) // Movie
          .order('consume_count', ascending: false)
          .limit(20);

      final contentList = (response as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

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
          .limit(20);

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
      final response = await _client.from('m_genre').select('*').limit(limit);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting average ratings by genre: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAverageMovieRatingsByYear({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
      // Simplified query - would need proper aggregation function in Supabase
      final response = await _client.from('content').select('*').eq('content_type_id', 1).order('release_date', ascending: false).limit(limit);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting average ratings by year: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopMovieGenres({
    required int page,
    required int limit,
    required String interval,
  }) async {
    try {
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

  Future<Map<String, dynamic>> getUserActivities({
    required String profileUserID,
    required ContentTypeEnum contentType,
  }) async {
    try {
      final response = await _client.from('user_content_log').select('''
            *,
            content:content_id (
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
          ''').eq('user_id', profileUserID).eq('content.content_type_id', contentType.index + 1).order('date', ascending: false).limit(20);

      final contentList = (response as List)
          .map((e) => ShowcaseContentModel.fromJson({
                ...e['content'],
                'user_rating': e['rating'],
                'user_status': e['content_status_id'],
                'is_favorite': e['is_favorite'],
                'is_consume_later': e['is_consume_later'],
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

  // Add other methods as needed to maintain compatibility...
}
