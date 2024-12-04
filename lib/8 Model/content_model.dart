import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/cast_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:intl/intl.dart';

class ContentModel {
  ContentModel({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.contentType,
    required this.releaseDate,
    required this.creatorList,
    required this.description,
    required this.genreList,
    required this.length,
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
  final String posterPath;
  final ContentTypeEnum contentType;
  final String title;
  final String description;
  final DateTime? releaseDate;
  final List<CastModel>? creatorList;
  final List<GenreModel>? genreList;
  final int? length;
  final List<CastModel>? cast;

  // TODO: filmin bilgileri, istatistikleri ve kullanıcı logu ayrı modelde mi tutulsa
  int consumeCount;
  int favoriCount;
  int listCount;
  int reviewCount;
  List<int> ratingDistribution;

  double? rating;
  ContentStatusEnum? contentStatus;
  bool isFavorite;
  bool isConsumeLater;

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['title'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      // releaseDate: json['release_date'] is int ? DateTime.fromMillisecondsSinceEpoch(json['release_date'] * 1000) : DateTime.parse(json['release_date']),
      releaseDate: json['release_date'] != null ? DateTime.parse(json['release_date']) : null,
      creatorList: json['creator_list'] != null ? (json['creator_list'] as List).map((i) => CastModel.fromJson(i)).toList() : null,
      description: json['description'],
      genreList: json['genre_list'] != null ? (json['genre_list'] as List).map((i) => GenreModel.fromJson(i)).toList() : null,
      // TODO: game timestamp fix
      length: json['length'],
      cast: json['cast_list'] != null ? (json['cast_list'] as List).map((i) => CastModel.fromJson(i)).toList() : null,
      consumeCount: json['consume_count'],
      favoriCount: json['favori_count'],
      listCount: json['list_count'],
      reviewCount: json['review_count'],
      ratingDistribution: json['rating_distribution'] != null ? (json['rating_distribution'] as List).map((i) => i as int).toList() : [],
      contentStatus: json['content_status_id'] != null ? ContentStatusEnum.values[json['content_status_id'] - 1] : null,
      rating: json['rating'] != null ? (json['rating'] is int ? json['rating'].toDouble() : double.parse(json['rating'])) : 0,
      isFavorite: json['is_favorite'] ?? false,
      isConsumeLater: json['is_consume_later'] ?? false,
    );
  }

  static List<ContentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((i) => ContentModel.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_path': posterPath,
      'title': title,
      'content_type_id': contentType.index,
      'release_date': releaseDate != null ? DateFormat('yyyy-MM-dd').format(releaseDate!) : null,
      'creator_list': creatorList?.map((i) => i.toJson()).toList(),
      'description': description,
      'genre_list': genreList?.map((i) => i.toJson()).toList(),
      'length': length,
      'cast_list': cast!.map((i) => i.toJson()).toList(),
      'consume_count': consumeCount,
      'favori_count': favoriCount,
      'list_count': listCount,
      'review_count': reviewCount,
      'rating_distribution': ratingDistribution,
      'content_status_id': contentStatus!.index,
      'rating': rating,
      'is_favorite': isFavorite,
      'is_consume_later': isConsumeLater,
    };
  }
}
