import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';

class ContentLogModel {
  ContentLogModel({
    required this.id,
    required this.userID,
    required this.contentID,
    required this.date,
    this.contentStatus,
    this.rating,
    this.isFavorite = false,
    this.isConsumeLater = false,
    this.review,
    required this.contentType,
  });

  final int id;
  final String userID;
  final int contentID;
  ContentStatusEnum? contentStatus;
  final DateTime date;
  final ContentTypeEnum contentType;

  double? rating;
  bool isFavorite;
  String? review;
  bool isConsumeLater;
}
