import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class ContentModel {
  ContentModel({
    required this.id,
    required this.title,
    required this.contentType,
    required this.year,
    required this.creator,
    required this.description,
    //
    required this.genre,
    required this.lenght,
    required this.platform,
    required this.cast,
    //
    required this.watchCount,
    required this.favoriCount,
    required this.listCount,
    required this.reviewCount,
    required this.ratingDistribution,
  });

  final int id;
  final ContentTypeEnum contentType;
  final String title;
  final String description;
  final int year;
  final List<String> creator;
  //
  final List<String> genre;
  final int lenght;
  final List<String>? platform;
  final List<String>? cast;

  //
  final int watchCount;
  final int favoriCount;
  final int listCount;
  final int reviewCount;
  final List<int> ratingDistribution;
}
