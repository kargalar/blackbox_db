import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class MovieLogModel {
  MovieLogModel({
    this.id,
    required this.userID,
    required this.movieID,
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
  final int movieID;
  ContentStatusEnum? contentStatus;
  final DateTime date;
  final String? contentTitle;
  final ContentTypeEnum contentType;

  double? rating;
  bool isFavorite;
  String? review;
  bool isConsumeLater;

  factory MovieLogModel.fromJson(Map<String, dynamic> json) {
    return MovieLogModel(
      id: json['id'],
      userID: json['user_id'],
      movieID: json['content_id'],
      date: DateTime.parse(json['date']),
      contentStatus: ContentStatusEnum.values[json['content_status_id'] - 1],
      rating: double.parse(json['rating']),
      isFavorite: json['is_favorite'],
      isConsumeLater: json['is_consume_later'],
      review: json['review'],
      contentTitle: json['content_title'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
    );
  }

  static List<MovieLogModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => MovieLogModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userID,
      'content_id': movieID,
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
