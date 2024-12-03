import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_status_enum.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/movie_log_model.dart';
import 'package:blackbox_db/8%20Model/movie_model.dart';
import 'package:flutter/material.dart';

class MoviePageProvider with ChangeNotifier {
  static final MoviePageProvider _instance = MoviePageProvider._internal();

  factory MoviePageProvider() {
    return _instance;
  }

  MoviePageProvider._internal();

  MovieModel? movieModel;

  // ? contentId null ise contentPage de demek

  Future<void> movieUserAction({
    int? movieId,
    required ContentTypeEnum contentType,
    required ContentStatusEnum? contentStatus,
    required double? rating,
    required bool isFavorite,
    required bool isConsumeLater,
  }) async {
    final MovieLogModel userLog = MovieLogModel(
      // TODO: id ve diğerleri. böyle ayrı ayrı olmak yerine 1 tane fonksiyon oluşturayım orada verilenlere göre mi loglayayım. ya da sadece log u dışarı çıkarayım.
      userID: userID,
      // TODO: date postgresql tarafında yapılabilir.
      date: DateTime.now(),
      movieID: movieId ?? movieModel!.id,
      contentType: contentType,
      // review: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps",
    );

    if (movieId == null) {
      movieModel!.contentStatus = contentStatus;
      movieModel!.rating = rating;
      movieModel!.isFavorite = isFavorite;
      movieModel!.isConsumeLater = isConsumeLater;
    }
    userLog.contentStatus = contentStatus;
    userLog.rating = rating;
    userLog.isFavorite = isFavorite;
    userLog.isConsumeLater = isConsumeLater;

    await ServerManager().movieUserAction(movieLogModel: userLog);

    if (movieId == null) {
      notifyListeners();
    }
  }

  // void favorite() {
  //   contentModel!.isFavorite = !contentModel!.isFavorite;

  //   notifyListeners();
  // }

  // void consumeLater() {
  //   contentModel!.isConsumeLater = !contentModel!.isConsumeLater;

  //   notifyListeners();
  // }

  // void rating(double rating) {
  //   // kaydırırken her sefeirnde kaydetmemek için kullanıcı kaydırmayı bitirdiği zaman göderilsin.
  //   contentModel!.rating = rating;

  //   notifyListeners();
  // }

  // TODO: review
}
