import 'package:blackbox_db/1_Core/Enums/status_enum.dart';
import 'package:blackbox_db/1_Core/helper.dart';
import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:blackbox_db/8_Model/content_model_supabase.dart';
import 'package:blackbox_db/8_Model/genre_model.dart';
import 'package:blackbox_db/8_Model/language_model.dart';
import 'package:blackbox_db/8_Model/user_model_supabase.dart';
import 'package:blackbox_db/8_Model/user_review_model.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._privateConstructor();

  static final SupabaseService _instance = SupabaseService._privateConstructor();

  factory SupabaseService() {
    return _instance;
  }

  final SupabaseClient _client = Supabase.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;
  String? get currentUserId => _client.auth.currentUser?.id;

  // ********************************************
  // AUTH METHODS
  // ********************************************

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user != null) {
        // Wait a bit for the trigger to create the user profile
        await Future.delayed(const Duration(milliseconds: 500));
        return await getUserProfile(response.user!.id);
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
  }

  Future<UserModel?> signIn({
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
        return await getUserProfile(response.user!.id);
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

  Future<void> signOut() async {
    await _client.auth.signOut();
    loginUser = null;
  }

  Future<UserModel?> getUserProfile(String authUserId) async {
    try {
      final response = await _client.from('app_user').select('*').eq('auth_user_id', authUserId).single();

      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // ********************************************
  // USER METHODS
  // ********************************************

  Future<UserModel?> getUserInfo({required String userId}) async {
    try {
      // Get user basic info with statistics
      final response = await _client.rpc('get_user_info_with_stats', params: {
        'user_uuid': userId,
        'profile_user_uuid': userId,
      });

      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting user info: $e');
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _client.from('app_user').select('*').order('created_at', ascending: false);

      return (response as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }

  Future<void> deleteUser({required String userId}) async {
    try {
      await _client.from('app_user').delete().eq('id', userId);
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? username,
    String? bio,
    String? picturePath,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;
      if (picturePath != null) updates['picture_path'] = picturePath;

      if (updates.isNotEmpty) {
        await _client.from('app_user').update(updates).eq('auth_user_id', currentUserId!);
      }
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  // ********************************************
  // CONTENT METHODS
  // ********************************************

  Future<ContentModel> getContentDetail({
    required int contentId,
    required ContentTypeEnum contentType,
    String? userId,
  }) async {
    try {
      final response = await _client.rpc('get_content_detail', params: {
        'content_id_param': contentId,
        'content_type_param': contentType.index + 1,
        'user_id_param': userId ?? currentUserId,
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

  Future<int> addContent({required ContentModel contentModel}) async {
    try {
      final response = await _client.from('content').insert(contentModel.toSupabaseJson()).select('id').single();

      return response['id'];
    } catch (e) {
      debugPrint('Error adding content: $e');
      rethrow;
    }
  }

  Future<void> updateContent({required ContentModel contentModel}) async {
    try {
      await _client.from('content').update(contentModel.toSupabaseJson()).eq('id', contentModel.id!);
    } catch (e) {
      debugPrint('Error updating content: $e');
      rethrow;
    }
  }

  Future<void> deleteContent({required int contentId}) async {
    try {
      await _client.from('content').delete().eq('id', contentId);
    } catch (e) {
      debugPrint('Error deleting content: $e');
      rethrow;
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
        'user_id': contentLogModel.userId,
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
              'user_id': contentLogModel.userId,
              'content_id': contentLogModel.contentID,
              'text': contentLogModel.review,
            })
            .select('id')
            .single();

        reviewId = reviewResponse['id'];
      }

      data['review_id'] = reviewId;

      // Upsert user content log
      await _client.from('user_content_log').upsert(data);
    } catch (e) {
      debugPrint('Error in content user action: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserContents({
    required String userId,
    required String logUserId,
    required ContentTypeEnum contentType,
    required int page,
    int limit = 20,
  }) async {
    try {
      final response = await _client.rpc('get_user_contents', params: {
        'user_id_param': userId,
        'log_user_id_param': logUserId,
        'content_type_param': contentType.index + 1,
        'page_param': page,
        'limit_param': limit,
      });

      final List<ShowcaseContentModel> contentList = (response['contents'] as List).map((e) => ShowcaseContentModel.fromJson(e)).toList();

      return {
        'contentList': contentList,
        'totalPages': response['total_pages'],
      };
    } catch (e) {
      debugPrint('Error getting user contents: $e');
      return {'contentList': <ShowcaseContentModel>[], 'totalPages': 0};
    }
  }

  // ********************************************
  // TREND & RECOMMENDATION METHODS
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
        'user_id_param': userId,
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
  // REVIEW METHODS
  // ********************************************

  Future<List<ReviewModel>> getContentReviews({
    required int contentId,
  }) async {
    try {
      final response = await _client.from('review').select('''
            *,
            app_user:auth_user_id (
              auth_user_id,
              username,
              picture_path
            )
          ''').eq('content_id', contentId).order('created_at', ascending: false);

      return (response as List).map((e) => ReviewModel.fromJson(e)).toList();
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
      final query = _client.from('review').select('''
            *,
            content:content_id (
              id,
              title,
              poster_path,
              content_type_id
            )
          ''').eq('user_id', userId).order('created_at', ascending: false);

      if (contentType != null) {
        // This would need a more complex query or RPC function
        // to filter by content type properly
      }

      final response = await query;
      return (response as List).map((e) => UserReviewModel.fromJson(e)).toList();
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
    required String followingUserId,
  }) async {
    try {
      // Check if already following
      final existing = await _client.from('user_follow').select('id').eq('user_id', userId).eq('following_user_id', followingUserId).maybeSingle();

      if (existing != null) {
        // Unfollow
        await _client.from('user_follow').delete().eq('user_id', userId).eq('following_user_id', followingUserId);
      } else {
        // Follow
        await _client.from('user_follow').insert({
          'user_id': userId,
          'following_user_id': followingUserId,
        });
      }
    } catch (e) {
      debugPrint('Error in follow/unfollow: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getFollowers({
    required String userId,
  }) async {
    try {
      final response = await _client.from('user_follow').select('''
            app_user:user_id (
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

  Future<List<Map<String, dynamic>>> getFollowing({
    required String userId,
  }) async {
    try {
      final response = await _client.from('user_follow').select('''
            app_user:following_user_id (
              auth_user_id,
              username,
              picture_path
            )
          ''').eq('user_id', userId);

      return (response as List)
          .map((e) => {
                'id': e['app_user']['auth_user_id'],
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
  // GENRE & LANGUAGE METHODS
  // ********************************************

  Future<List<GenreModel>> getAllGenres({
    required ContentTypeEnum contentType,
  }) async {
    try {
      final tableName = contentType == ContentTypeEnum.MOVIE ? 'm_genre' : 'g_genre';
      final response = await _client.from(tableName).select('*').order('name');

      return (response as List).map((e) => GenreModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting genres: $e');
      return [];
    }
  }

  Future<List<LanguageModel>> getAllLanguages({
    required ContentTypeEnum contentType,
  }) async {
    try {
      final tableName = contentType == ContentTypeEnum.MOVIE ? 'm_language' : 'g_language';
      final response = await _client.from(tableName).select('*').order('name');

      return (response as List).map((e) => LanguageModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting languages: $e');
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
      final response = await _client.rpc('get_top_actors_by_movie_count', params: {
        'page_param': page,
        'limit_param': limit,
        'interval_param': interval,
      });

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
      final response = await _client.rpc('get_most_watched_movies', params: {
        'page_param': page,
        'limit_param': limit,
        'interval_param': interval,
      });

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error getting most watched movies: $e');
      return [];
    }
  }

  // Add more statistics methods as needed...
}
