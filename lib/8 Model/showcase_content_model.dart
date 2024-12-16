import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';

class ShowcaseContentModel {
  ShowcaseContentModel({
    this.userID,
    required this.contentId,
    required this.posterPath,
    required this.contentType,
    required this.isFavorite,
    required this.isConsumed,
    required this.isConsumeLater,
    this.contentLog,
    this.trendIndex,
  });

  final int? userID;
  final int contentId;
  final String? posterPath;
  final ContentTypeEnum contentType;
  bool isFavorite;
  bool isConsumed;
  bool isConsumeLater;

  final ContentLogModel? contentLog;

  int? trendIndex;

  factory ShowcaseContentModel.fromJson(Map<String, dynamic> json) {
    return ShowcaseContentModel(
      userID: json['user_id'],
      contentId: json['content_id'],
      posterPath: json['poster_path'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      isFavorite: json['is_favorite'] ?? false,
      isConsumed: json['is_consumed'],
      isConsumeLater: json['is_consume_later'] ?? false,
      contentLog: json['userLog'] != null ? ContentLogModel.fromJson(json['userLog']) : null,
    );
  }

  static List<ShowcaseContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }
}
