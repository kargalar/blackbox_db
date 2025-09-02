import 'package:blackbox_db/7_Enum/content_type_enum.dart';

class UserReviewModel {
  UserReviewModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.contentId,
    required this.contentType,
    required this.title,
    required this.posterPath,
    this.rating,
    this.isFavorite = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLikedByCurrentUser = false,
  });

  int id;
  String text;
  DateTime createdAt;
  int contentId;
  ContentTypeEnum contentType;
  String title;
  String posterPath;
  double? rating;
  bool isFavorite;
  int likeCount;
  int commentCount;
  bool isLikedByCurrentUser;

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      contentId: json['content_id'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      title: json['title'],
      posterPath: json['poster_path'],
      rating: json['rating']?.toDouble(),
      isFavorite: json['is_favorite'] ?? false,
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      isLikedByCurrentUser: json['is_liked_by_current_user'] ?? false,
    );
  }

  static List<UserReviewModel> fromJsonList(List<dynamic> jsonList) {
    List<UserReviewModel> list = [];
    for (var json in jsonList) {
      list.add(UserReviewModel.fromJson(json));
    }
    return list;
  }
}
