import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/8%20Model/cast_model.dart';
import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:blackbox_db/8%20Model/creator_model.dart';
import 'package:blackbox_db/8%20Model/genre_model.dart';
import 'package:blackbox_db/8%20Model/platform_model.dart';
import 'package:flutter/material.dart';

class ContentPageProvider with ChangeNotifier {
  ContentModel contentModel = ContentModel(
    id: 1,
    title: "Hit the Road ",
    coverPath: "https://image.tmdb.org/t/p/original/s2VAydm53Odgafoto5NPLUeQgkX.jpg",
    contentType: ContentTypeEnum.MOVIE,
    year: DateTime(2024),
    creatorList: [CreatorModel(id: 0, name: "Panah Panhani")],
    description: "A chaotic family is on a road trip across a rugged landscape. In the back seat, Dad has a broken leg, Mom tries to laugh when she’s not holding back tears, and the youngest keeps exploding into car karaoke. Only the older brother is quiet.",
    genreList: [GenreModel(id: 0, title: "Action"), GenreModel(id: 1, title: "Sci-Fi"), GenreModel(id: 2, title: "Drama")],
    lenght: 138,
    platformList: [PlatformModel(id: 0, title: "Netflix")],
    cast: [CastModel(id: 0, name: "John David Washington"), CastModel(id: 1, name: "Robert Pattinson"), CastModel(id: 2, name: "Elizabeth Debicki")],
    watchCount: 1000,
    favoriCount: 100,
    listCount: 50,
    reviewCount: 10,
    ratingDistribution: [5, 2, 8, 22, 3],
    isWatched: false,
    rating: 3.5,
    isFavorited: false,
  );

  void watchContent() {
    contentModel.isWatched = !contentModel.isWatched;

    notifyListeners();
  }
}
