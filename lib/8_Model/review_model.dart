class ReviewModel {
  ReviewModel({
    required this.id,
    required this.picturePath,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
    this.rating,
    this.isFavorite = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLikedByCurrentUser = false,
  });

  int id;
  String? picturePath;
  String userId;
  String userName;
  String text;
  DateTime createdAt;
  double? rating;
  bool isFavorite;
  int likeCount;
  int commentCount; // This will now be the reply count
  bool isLikedByCurrentUser;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      picturePath: json['picture_path'],
      userId: json['user_id'],
      userName: json['username'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      rating: json['rating']?.toDouble(),
      isFavorite: json['is_favorite'] ?? false,
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      isLikedByCurrentUser: json['is_liked_by_current_user'] ?? false,
    );
  }

  static List<ReviewModel> fromJsonList(List<dynamic> jsonList) {
    List<ReviewModel> list = [];
    for (var json in jsonList) {
      list.add(ReviewModel.fromJson(json));
    }
    return list;
  }
}
