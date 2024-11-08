import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/cast_model.dart';
import 'package:blackbox_db/8%20Model/creator_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/platform_model.dart';

class ContentModel {
  ContentModel({
    required this.id,
    required this.title,
    required this.coverPath,
    required this.contentType,
    required this.year,
    required this.creatorList,
    required this.description,
    required this.genreList,
    required this.lenght,
    required this.platformList,
    required this.cast,
    required this.watchCount,
    required this.favoriCount,
    required this.listCount,
    required this.reviewCount,
    required this.ratingDistribution,
    required this.isWatch,
    required this.rating,
    required this.isFavorite,
    required this.isWatchLater,
  });

  final int id;
  final ContentTypeEnum contentType;
  final String title;
  final String coverPath;
  final String description;
  final DateTime year;
  final List<CreatorModel> creatorList;

  final List<GenreModel> genreList;
  final int lenght;
  final List<PlatformModel>? platformList;
  final List<CastModel>? cast;

  int watchCount;
  int favoriCount;
  int listCount;
  int reviewCount;
  List<int> ratingDistribution;

  double rating;
  bool isWatch;
  bool isFavorite;
  bool isWatchLater;
}
