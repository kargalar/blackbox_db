class UserReviewModel {
  UserReviewModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.contentId,
    required this.title,
    required this.posterPath,
  });

  int id;
  String text;
  DateTime createdAt;
  int contentId;
  String title;
  String posterPath;

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      contentId: json['content_id'],
      title: json['title'],
      posterPath: json['poster_path'],
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
