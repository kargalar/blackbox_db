import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class ShowcaseContentModel {
  ShowcaseContentModel({
    required this.contentId,
    required this.contentType,
    required this.isFavorite,
    required this.isConsumed,
    required this.isConsumeLater,
    required this.rating,
    required this.isReviewed,
  });

  final int contentId;
  final ContentTypeEnum contentType;
  final bool isFavorite;
  final bool isConsumed;
  final bool isConsumeLater;
  final double? rating;
  final bool isReviewed;

  factory ShowcaseContentModel.fromJson(Map<String, dynamic> json) {
    return ShowcaseContentModel(
      contentId: json['content_id'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      isFavorite: json['is_favorite'],
      isConsumed: json['is_consumed'],
      rating: double.parse(json['rating']),
      isReviewed: json['is_reviewed'],
      isConsumeLater: json['is_consume_later'],
    );
  }

  static List<ShowcaseContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': contentId,
      'content_type_id': contentType.index,
      'is_favori': isFavorite,
      'is_consumed': isConsumed,
      'rating': rating,
      'is_reviewed': isReviewed,
      'is_consume_later': isConsumeLater,
    };
  }
}
