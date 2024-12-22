import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';

class ShowcaseContentModel {
  ShowcaseContentModel({
    this.userID,
    required this.contentId,
    required this.posterPath,
    required this.contentType,
    required this.isFavorite,
    required this.contentStatus,
    required this.isConsumeLater,
    this.rating,
    this.contentLog,
    this.trendIndex,
  });

  final int? userID;
  final int contentId;
  final String? posterPath;
  final ContentTypeEnum contentType;
  bool isFavorite;
  ContentStatusEnum? contentStatus;
  bool isConsumeLater;
  double? rating;

  final ContentLogModel? contentLog;

  int? trendIndex;

  factory ShowcaseContentModel.fromJson(Map<String, dynamic> json) {
    return ShowcaseContentModel(
      userID: json['user_id'],
      contentId: json['content_id'],
      posterPath: json['poster_path'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      isFavorite: json['is_favorite'] ?? false,
      contentStatus: json['content_status_id'] != null ? ContentStatusEnum.values[json['content_status_id'] - 1] : null,
      isConsumeLater: json['is_consume_later'] ?? false,
      rating: json['rating'] != null
          ? (json['rating'] is int
              ? json['rating'].toDouble()
              : json['rating'] is String
                  ? double.parse(json['rating'])
                  : json['rating'])
          : null,
      contentLog: json['userLog'] != null ? ContentLogModel.fromJson(json['userLog']) : null,
    );
  }

  static List<ShowcaseContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }
}
