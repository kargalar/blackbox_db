// TODO: BUNU NEREDE KULLANIYORUM
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class ContentLogModel {
  ContentLogModel({
    this.id,
    required this.userID,
    required this.contentID,
    this.date,
    this.contentStatus,
    this.rating,
    this.isFavorite,
    this.isConsumeLater = false,
    this.review,
    // this.contentTitle,
    required this.contentType,
  });

  final int? id;
  final int userID;
  final int contentID;
  ContentStatusEnum? contentStatus;
  final DateTime? date;
  // final String? contentTitle;
  final ContentTypeEnum contentType;

  double? rating;
  bool? isFavorite;
  String? review;
  bool? isConsumeLater;

  //   is_consumed: row.is_consumed,

  // TODO:
  factory ContentLogModel.fromJson(Map<String, dynamic> json) {
    return ContentLogModel(
      id: json['id'],
      userID: json['user_id'],
      contentID: json['content_id'],
      date: DateTime.parse(json['date']),
      contentStatus: json['content_status_id'] == null ? null : ContentStatusEnum.values[json['content_status_id'] - 1],
      rating: json['rating'] != null ? double.parse(json['rating']) : null,
      isFavorite: json['is_favorite'],
      isConsumeLater: json['is_consume_later'],
      review: json['review_text'],
      // contentTitle: json['movie_title'],
      // contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      contentType: ContentTypeEnum.MOVIE,
    );
  }

  static List<ContentLogModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ContentLogModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userID,
      'content_id': contentID,
      'content_status_id': contentStatus!.index + 1,
      'review_text': rating,
      'is_favorite': isFavorite,
      'is_consume_later': isConsumeLater,
      'review': review,
      'content_type_id': contentType.index + 1,
    };
  }
}
