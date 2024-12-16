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
    required this.rating,
    required this.isReviewed,
    this.reviewText,
    this.contentLog,
    this.trendIndex,
    this.date,
  });

  final int? userID;
  final int contentId;
  final String? posterPath;
  final ContentTypeEnum contentType;
  bool isFavorite;
  bool isConsumed;
  bool isConsumeLater;

  // TODO: yukarıdakielr her zaman alınacak ama biris list ise biris activity ise alınacak. bunun için türüne göre farklı istek mı olsa. yani hepsini explore da yapmak yerine activity, list, explore gibi
  //
  // final bool isFavorite;
  double? rating;

  bool isReviewed;
  String? reviewText;

  DateTime? date;
  // TODO: yukarıdaki üçünü kapsayan bir model yapısı movieLog gibi
  //
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
      rating: json['rating'] != null ? double.parse(json['rating']) : null,
      // !!!!!!!
      // TODO: burad aisreviewed yerine direkt review text gelse logmodel gerekmez sanırım. bu yeterli olur. !!!!!!!
      isReviewed: json['is_reviewed'] ?? false,
      reviewText: json['review_text'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isConsumeLater: json['is_consume_later'] ?? false,
      // TODO: bunu kaldır onun yerine yukarıya review falana ne gerekiyorsa ekle ???
      // contentLog: json['userContentLogs'] != null ? ContentLogModel.fromJson(json['userContentLogs']) : null,
    );
  }

  static List<ShowcaseContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }
}
