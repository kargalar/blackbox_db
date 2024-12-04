import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class ContentLogModel {
  ContentLogModel({
    this.id,
    required this.userID,
    required this.contentID,
    required this.date,
    this.contentStatus,
    this.rating,
    this.isFavorite = false,
    this.isConsumeLater = false,
    this.review,
    this.contentTitle,
    required this.contentType,
  });

  final int? id;
  final int userID;
  final int contentID;
  ContentStatusEnum? contentStatus;
  final DateTime date;
  final String? contentTitle;
  final ContentTypeEnum contentType;

  double? rating;
  bool isFavorite;
  String? review;
  bool isConsumeLater;

  factory ContentLogModel.fromJson(Map<String, dynamic> json) {
    return ContentLogModel(
      id: json['id'],
      userID: json['user_id'],
      contentID: json['movie_id'],
      date: DateTime.parse(json['date']),
      contentStatus: ContentStatusEnum.values[json['content_status_id'] - 1],
      rating: double.parse(json['rating']),
      isFavorite: json['is_favorite'],
      isConsumeLater: json['is_consume_later'],
      review: json['review'],
      contentTitle: json['movie_title'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
    );
  }

  static List<ContentLogModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ContentLogModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userID,
      'movie_id': contentID,
      'date': date.toIso8601String(),
      'content_status_id': contentStatus!.index + 1,
      'rating': rating,
      'is_favorite': isFavorite,
      'is_consume_later': isConsumeLater,
      'review': review,
      'content_type_id': contentType.index + 1,
    };
  }
}
