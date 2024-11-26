import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/crew_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/platform_model.dart';
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
  final String posterPath;
  final ContentTypeEnum contentType;
  final String title;
  final String description;
  final DateTime releaseDate;
  final List<CrewModel> creatorList;
  final List<GenreModel> genreList;
  final int length;
  final List<PlatformModel>? platformList;
  final List<CrewModel>? cast;

  // TODO: filmin bilgileri, istatistikleri ve kullanıcı logu ayrı modelde mi tutulsa
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
      posterPath: json['poster_path'],
      title: json['title'],
      contentType: ContentTypeEnum.values[json['content_type_id']],
      releaseDate: DateTime.parse(json['release_date']),
      creatorList: (json['creator_list'] as List).map((i) => CrewModel.fromJson(i)).toList(),
      description: json['description'],
      genreList: (json['genre_list'] as List).map((i) => GenreModel.fromJson(i)).toList(),
      length: json['length'],
      platformList: (json['platform_list'] as List).map((i) => PlatformModel.fromJson(i)).toList(),
      cast: (json['cast_list'] as List).map((i) => CrewModel.fromJson(i)).toList(),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_path': posterPath,
      'title': title,
      'content_type_id': contentType.index,
      'release_date': DateFormat('yyyy-MM-dd').format(releaseDate),
      'creator_list': creatorList.map((i) => i.toJson()).toList(),
      'description': description,
      'genre_list': genreList.map((i) => i.toJson()).toList(),
      'length': length,
      'platform_list': platformList!.map((i) => i.toJson()).toList(),
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

  // TMDB
  factory ContentModel.fromJsonTMDB(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['title'],
      contentType: ContentTypeEnum.MOVIE,
      releaseDate: DateTime.parse(json['release_date']),
      creatorList: CrewModel.fromJsonList(json['credits']['crew'].where((item) => item['department'] == 'Directing').toList().sublist(0, 1)),
      description: json['overview'],
      genreList: (json['genres'] as List<dynamic>).map((e) => GenreModel(id: e['id'], title: e['name'])).toList(),
      length: json['runtime'],
      platformList: [], // TMDB'den bu bilgi gelmez, varsayılan olarak boş liste
      // TODO: 5 den az olursa sorun olur mu?
      cast: CrewModel.fromJsonList(json['credits']['cast']).sublist(0, 5),
      consumeCount: 0, // TMDB'den bu bilgi gelmez, varsayılan olarak 0
      favoriCount: 0, // TMDB'den bu bilgi gelmez, varsayılan olarak 0
      listCount: 0, // TMDB'den bu bilgi gelmez, varsayılan olarak 0
      reviewCount: 0, // TMDB'den bu bilgi gelmez, varsayılan olarak 0
      ratingDistribution: [], // TMDB'den bu bilgi gelmez, varsayılan olarak boş liste
      contentStatus: null,
      rating: 0,
      isFavorite: false,
      isConsumeLater: false,
    );
  }
}
