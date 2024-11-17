import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/cast_model.dart';
import 'package:blackbox_db/8%20Model/creator_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/platform_model.dart';

class ContentModel {
  ContentModel({
    required this.id,
    required this.title,
    required this.contentType,
    required this.year,
    required this.creatorList,
    required this.description,
    required this.genreList,
    required this.lenght,
    required this.platformList,
    required this.cast,
    required this.consumeCount,
    required this.favoriCount,
    required this.listCount,
    required this.reviewCount,
    required this.ratingDistribution,
    required this.contentStatus,
    required this.rating,
    required this.isFavorite,
    required this.isConsumeLater,
  });

  final int id;
  final ContentTypeEnum contentType;
  final String title;
  final String description;
  final DateTime year;
  final List<CreatorModel> creatorList;

  final List<GenreModel> genreList;
  final int lenght;
  final List<PlatformModel>? platformList;
  final List<CastModel>? cast;

  int consumeCount;
  int favoriCount;
  int listCount;
  int reviewCount;
  List<int> ratingDistribution;

  double rating;
  ContentStatusEnum? contentStatus;
  bool isFavorite;
  bool isConsumeLater;

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      title: json['title'],
      contentType: ContentTypeEnum.values[json['content_type_id']],
      year: DateTime.parse(json['release_date']),
      creatorList: (json['creator_list'] as List).map((i) => CreatorModel.fromJson(i)).toList(),
      description: json['description'],
      genreList: (json['genre_list'] as List).map((i) => GenreModel.fromJson(i)).toList(),
      lenght: json['length'],
      platformList: (json['platform_list'] as List).map((i) => PlatformModel.fromJson(i)).toList(),
      cast: (json['cast_list'] as List).map((i) => CastModel.fromJson(i)).toList(),
      consumeCount: json['consume_count'],
      favoriCount: json['favori_count'],
      listCount: json['list_count'],
      reviewCount: json['review_count'],
      ratingDistribution: (json['rating_distribution'] as List).map((i) => i as int).toList(),
      contentStatus: json['content_status_id'] != null ? ContentStatusEnum.values[json['content_status_id']] : null,
      rating: json['rating'],
      isFavorite: json['is_favorite'],
      isConsumeLater: json['is_consume_later'],
    );
  }

  static List<ContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((i) => ContentModel.fromJson(i)).toList();
  }
}
