import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/content_log_model.dart';

class ShowcaseContentModel {
  ShowcaseContentModel({required this.contentId, required this.contentPosterPath, required this.contentType, required this.isFavorite, required this.isConsumed, required this.isConsumeLater, required this.rating, required this.isReviewed, this.contentLog, this.trendIndex});

  final int contentId;
  final String? contentPosterPath;
  final ContentTypeEnum contentType;
  final bool isFavorite;
  final bool isConsumed;
  final bool isConsumeLater;

  // TODO: yukarıdakielr her zaman alınacak ama biris list ise biris activity ise alınacak. bunun için türüne göre farklı istek mı olsa. yani hepsini explore da yapmak yerine activity, list, explore gibi
  //
  // final bool isFavorite;
  final double? rating;
  final bool isReviewed;
  // TODO: yukarıdaki üçünü kapsayan bir model yapısı contentLog gibi
  //
  final ContentLogModel? contentLog;

  final int? trendIndex;

  factory ShowcaseContentModel.fromJson(Map<String, dynamic> json) {
    return ShowcaseContentModel(
      contentId: json['content_id'],
      // TODO: normalde
      contentPosterPath: json['content_poster_path'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      isFavorite: json['is_favorite'],
      isConsumed: json['is_consumed'],
      rating: double.parse(json['rating']),
      isReviewed: json['is_reviewed'],
      isConsumeLater: json['is_consume_later'],
      contentLog: json['content_log'] != null ? ContentLogModel.fromJson(json['content_log']) : null,
    );
  }

  static List<ShowcaseContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ShowcaseContentModel.fromJson(e)).toList();
  }

  // TMDB
  factory ShowcaseContentModel.fromJsonTMDB(Map<String, dynamic> json) {
    return ShowcaseContentModel(
      contentId: json['id'],
      contentPosterPath: json['poster_path'],
      contentType: ContentTypeEnum.MOVIE,
      isFavorite: false,
      isConsumed: false,
      isConsumeLater: false,
      rating: null,
      isReviewed: false,
      contentLog: null,
      trendIndex: null,
    );
  }

  static List<ShowcaseContentModel> fromJsonTMDBList(Map<String, dynamic> jsonMap) {
    final results = jsonMap['results'] as List<dynamic>;
    return results.map((e) => ShowcaseContentModel.fromJsonTMDB(e)).toList();
  }
}
