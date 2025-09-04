import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/8_Model/cast_model.dart';
import 'package:blackbox_db/8_Model/genre_model.dart';
import 'package:intl/intl.dart';

class ContentModel {
  ContentModel({
    required this.id,
    this.posterPath,
    required this.title,
    required this.contentType,
    this.releaseDate,
    this.creatorList,
    this.description,
    this.genreList,
    this.platformList,
    this.length,
    this.cast,
    this.consumeCount,
    this.favoriCount,
    this.listCount,
    this.reviewCount,
    this.ratingDistribution,
    this.contentStatus,
    this.rating,
    this.isFavorite,
    this.isConsumeLater,
  });

  int? id;
  final String? posterPath;
  final ContentTypeEnum contentType;
  final String title;
  final String? description;
  final DateTime? releaseDate;
  final List<CastModel>? creatorList;
  final List<GenreModel>? genreList;
  // Platforms for games (and optionally movies if ever used). Reuse GenreModel shape {id,name}.
  final List<GenreModel>? platformList;
  final int? length;
  final List<CastModel>? cast;

  // TODO: filmin bilgileri, istatistikleri ve kullanıcı logu ayrı modelde mi tutulsa
  int? consumeCount;
  int? favoriCount;
  int? listCount;
  int? reviewCount;
  List<int>? ratingDistribution;

  double? rating;
  ContentStatusEnum? contentStatus;
  bool? isFavorite;
  bool? isConsumeLater;

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['content_id'],
      posterPath: json['poster_path'],
      title: json['title'],
      contentType: ContentTypeEnum.values[json['content_type_id'] - 1],
      // releaseDate: json['release_date'] is int ? DateTime.fromMillisecondsSinceEpoch(json['release_date'] * 1000) : DateTime.parse(json['release_date']),
      releaseDate: (json['release_date'] != null && json['release_date'] != "") ? DateTime.parse(json['release_date']) : null,
      creatorList: json['creator_list'] != null ? (json['creator_list'] as List).map((i) => CastModel.fromJson(i)).toList() : null,
      description: json['description'],
      genreList: json['genre_list'] != null ? (json['genre_list'] as List).map((i) => GenreModel.fromJson(i)).toList() : null,
      platformList: json['platform_list'] != null ? (json['platform_list'] as List).map((i) => GenreModel.fromJson(i)).toList() : null,
      // TODO: game timestamp fix
      length: json['length'],
      cast: json['cast_list'] != null ? (json['cast_list'] as List).map((i) => CastModel.fromJson(i)).toList() : null,
      consumeCount: json['consume_count'] ?? 0,
      // Supabase returns favorite_count, keep backward compat with favori_count
      favoriCount: json['favorite_count'] ?? json['favori_count'] ?? 0,
      listCount: json['list_count'] ?? 0,
      reviewCount: json['review_count'] ?? 0,
      ratingDistribution: json['rating_distribution'] != null ? (json['rating_distribution'] as List).map((i) => i as int).toList() : [],
      contentStatus: json['content_status_id'] != null ? ContentStatusEnum.values[json['content_status_id'] - 1] : null,
      rating: json['rating'] != null
          ? (json['rating'] is int
              ? json['rating'].toDouble()
              : json['rating'] is String
                  ? double.parse(json['rating'])
                  : json['rating'])
          : null,
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
      'content_type_id': contentType.index + 1,
      'release_date': releaseDate != null ? DateFormat('yyyy-MM-dd').format(releaseDate!) : null,
      'creator_list': creatorList?.map((i) => i.toJson()).toList(),
      'description': description,
      'genre_list': genreList?.map((i) => i.toJson()).toList(),
      'length': length,
      'cast_list': cast?.map((i) => i.toJson()).toList(),
      'consume_count': consumeCount,
      'favori_count': favoriCount,
      'list_count': listCount,
      'review_count': reviewCount,
      'rating_distribution': ratingDistribution,
      'content_status_id': contentStatus?.index,
      'rating': rating,
      'is_favorite': isFavorite,
      'is_consume_later': isConsumeLater,
    };
  }

  ContentModel copyWith({
    int? id,
    String? posterPath,
    ContentTypeEnum? contentType,
    String? title,
    String? description,
    DateTime? releaseDate,
    List<CastModel>? creatorList,
    List<GenreModel>? genreList,
    List<GenreModel>? platformList,
    int? length,
    List<CastModel>? cast,
    int? consumeCount,
    int? favoriCount,
    int? listCount,
    int? reviewCount,
    List<int>? ratingDistribution,
    double? rating,
    ContentStatusEnum? contentStatus,
    bool? isFavorite,
    bool? isConsumeLater,
  }) {
    final copy = ContentModel(
      id: id ?? this.id,
      posterPath: posterPath ?? this.posterPath,
      title: title ?? this.title,
      contentType: contentType ?? this.contentType,
      releaseDate: releaseDate ?? this.releaseDate,
      creatorList: creatorList ?? this.creatorList,
      description: description ?? this.description,
      genreList: genreList ?? this.genreList,
      platformList: platformList ?? this.platformList,
      length: length ?? this.length,
      cast: cast ?? this.cast,
      consumeCount: consumeCount ?? this.consumeCount,
      favoriCount: favoriCount ?? this.favoriCount,
      listCount: listCount ?? this.listCount,
      reviewCount: reviewCount ?? this.reviewCount,
      ratingDistribution: ratingDistribution ?? this.ratingDistribution,
      contentStatus: contentStatus ?? this.contentStatus,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isConsumeLater: isConsumeLater ?? this.isConsumeLater,
    );
    return copy;
  }
}
