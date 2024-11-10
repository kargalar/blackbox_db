import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class ContentLogModel {
  ContentLogModel({
    required this.id,
    required this.date,
    required this.contentID,
    required this.contentTitle,
    required this.contentCoverPath,
    required this.contentType,
    this.contentStatus,
    this.rating,
    this.isFavorite = false,
    this.isConsumeLater = false,
    this.review,
  });

  final int id;
  final DateTime date;
  final int contentID;
  final ContentTypeEnum contentType;
  final String contentTitle;
  final String contentCoverPath;

  double? rating;
  ContentStatusEnum? contentStatus;
  bool isFavorite;
  bool isConsumeLater;
  String? review;
}
