import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class SearchMovieModel {
  SearchMovieModel({
    required this.movieId,
    required this.moviePosterPath,
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

  final int movieId;
  final String? moviePosterPath;
  final ContentTypeEnum contentType;
  final bool isFavorite;
  final bool isConsumed;
  final bool isConsumeLater;

  final double? rating;
  final bool isReviewed;

  final String title;
  final String description;
  final String year;
  final String? originalTitle;

  // TODO bu model content model deki notlarla onun gibi güncellenecek

  // TMDB
  factory SearchMovieModel.fromJsonTMDB(Map<String, dynamic> json) {
    return SearchMovieModel(
      movieId: json['id'],
      moviePosterPath: json['poster_path'],
      contentType: ContentTypeEnum.MOVIE,
      // TODO: bunlar backendden gelecek
      isFavorite: false,
      isConsumed: false,
      isConsumeLater: false,
      rating: null,
      isReviewed: false,
      title: json['title'],
      description: json['overview'],
      year: json['release_date'] != "" ? json['release_date'].substring(0, 4) : "",
      originalTitle: json['original_title'],
    );
  }

  static List<SearchMovieModel> fromJsonTMDBList(Map<String, dynamic> jsonMap) {
    final results = jsonMap['results'] as List<dynamic>;
    return results.map((e) => SearchMovieModel.fromJsonTMDB(e)).toList();
  }
}
