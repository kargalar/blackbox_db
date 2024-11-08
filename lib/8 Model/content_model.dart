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

  final int watchCount;
  final int favoriCount;
  final int listCount;
  final int reviewCount;
  final List<int> ratingDistribution;
}
