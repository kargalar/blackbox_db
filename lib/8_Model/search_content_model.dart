import 'package:blackbox_db/7_Enum/content_type_enum.dart';

class SearchContentModel {
  SearchContentModel({
    required this.contentId,
    required this.contentPosterPath,
    required this.contentType,
    required this.isFavorite,
    required this.isConsumed,
    required this.isConsumeLater,
    required this.rating,
    required this.isReviewed,
    //
    required this.title,
    required this.description,
    required this.year,
    required this.originalTitle,
  });

  final int contentId;
  final String? contentPosterPath;
  final ContentTypeEnum contentType;
  final bool isFavorite;
  final bool isConsumed;
  final bool isConsumeLater;

  final double? rating;
  final bool isReviewed;

  final String title;
  final String? description;
  final String? year;
  final String? originalTitle;

  // TODO bu model content model deki notlarla onun gibi güncellenecek

  // TMDB
  factory SearchContentModel.fromJsonTMDB(Map<String, dynamic> json) {
    return SearchContentModel(
      contentId: json['id'],
      contentPosterPath: json['poster_path'],
      contentType: ContentTypeEnum.MOVIE,
      title: json['title'],
      description: json['overview'],
      year: json['release_date'] != "" ? json['release_date'].substring(0, 4) : "",
      originalTitle: json['original_title'],

      // TODO: bunlar backendden gelecek
      isFavorite: false,
      isConsumed: false,
      isConsumeLater: false,
      rating: null,
      isReviewed: false,
    );
  }

  static List<SearchContentModel> fromJsonTMDBList(Map<String, dynamic> jsonMap) {
    final results = jsonMap['results'] as List<dynamic>;
    return results.map((e) => SearchContentModel.fromJsonTMDB(e)).toList();
  }

  // IGDB
  factory SearchContentModel.fromJsonIGDB(Map<String, dynamic> json) {
    return SearchContentModel(
      contentId: json['id'],
      contentPosterPath: json['cover'] != null ? json['cover']['image_id'] : null,
      contentType: ContentTypeEnum.GAME,
      title: json['name'],
      description: json['summary'],
      year: json['first_release_date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['first_release_date'] * 1000).year.toString() : null,
      originalTitle: json['name'],

      // TODO: bunlar backendden gelecek
      isFavorite: false,
      isConsumed: false,
      isConsumeLater: false,
      rating: null,
      isReviewed: false,
    );
  }

  static List<SearchContentModel> fromJsonIGDBList(List<dynamic> jsonList) {
    return jsonList.map((e) => SearchContentModel.fromJsonIGDB(e)).toList();
  }
}
