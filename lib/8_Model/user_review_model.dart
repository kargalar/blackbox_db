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
  });

  int id;
  String text;
  DateTime createdAt;
  int contentId;
  ContentTypeEnum contentType;
  String title;
  String posterPath;

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      contentId: json['content_id'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
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
