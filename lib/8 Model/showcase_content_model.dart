import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';

class ShowcaseContentModel {
  ShowcaseContentModel({
    required this.id,
    required this.contentType,
    required this.showcaseType,
    required this.isFavori,
    required this.isWatched,
    required this.isWatchlist,
  });

  final int id;
  final ContentTypeEnum contentType;
  final ShowcaseTypeEnum showcaseType;
  final bool isFavori;
  final bool isWatched;
  final bool isWatchlist;
}
