class ReviewReplyModel {
  ReviewReplyModel({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.userName,
    required this.userPicturePath,
    required this.text,
    required this.createdAt,
    this.parentReplyId,
    this.parentUserName,
    this.updatedAt,
    this.replies = const [],
    this.likeCount = 0,
    this.isLikedByCurrentUser = false,
  });

  int id;
  int reviewId;
  String userId;
  String userName;
  String? userPicturePath;
  String text;
  DateTime createdAt;
  int? parentReplyId;
  String? parentUserName; // For showing "@username" in nested replies
  DateTime? updatedAt;
  List<ReviewReplyModel> replies; // For nested structure
  int likeCount;
  bool isLikedByCurrentUser;

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) {
    return ReviewReplyModel(
      id: json['id'],
      reviewId: json['review_id'],
      userId: json['user_id'],
      userName: json['username'] ?? json['user_name'] ?? 'Unknown User',
      userPicturePath: json['picture_path'] ?? json['user_picture_path'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      parentReplyId: json['parent_reply_id'],
      parentUserName: json['parent_user_name'],
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      replies: json['replies'] != null ? (json['replies'] as List).map((e) => ReviewReplyModel.fromJson(e)).toList() : [],
      likeCount: json['like_count'] ?? 0,
      isLikedByCurrentUser: json['is_liked_by_current_user'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review_id': reviewId,
      'user_id': userId,
      'username': userName,
      'picture_path': userPicturePath,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'parent_reply_id': parentReplyId,
      'parent_user_name': parentUserName,
      'updated_at': updatedAt?.toIso8601String(),
      'replies': replies.map((e) => e.toJson()).toList(),
      'like_count': likeCount,
      'is_liked_by_current_user': isLikedByCurrentUser,
    };
  }

  static List<ReviewReplyModel> fromJsonList(List<dynamic> jsonList) {
    List<ReviewReplyModel> list = [];
    for (var json in jsonList) {
      list.add(ReviewReplyModel.fromJson(json));
    }
    return list;
  }

  // Helper method to get total reply count including nested replies
  int get totalReplyCount {
    int count = 1; // Count this reply
    for (var reply in replies) {
      count += reply.totalReplyCount;
    }
    return count;
  }
}
