enum ExploreSortEnum {
  defaultOrder,
  ratingDesc, // user rating
  ratingAsc, // user rating
  yearDesc,
  yearAsc,
  globalRatingDesc,
  globalRatingAsc,
  popularityDesc,
  watchlistFirst,
}

extension ExploreSortEnumExtension on ExploreSortEnum {
  String get label {
    switch (this) {
      case ExploreSortEnum.defaultOrder:
        return 'Default';
      case ExploreSortEnum.ratingDesc:
        return 'User Rating ↓';
      case ExploreSortEnum.ratingAsc:
        return 'User Rating ↑';
      case ExploreSortEnum.yearDesc:
        return 'Year ↓';
      case ExploreSortEnum.yearAsc:
        return 'Year ↑';
      case ExploreSortEnum.globalRatingDesc:
        return 'Global Rating ↓';
      case ExploreSortEnum.globalRatingAsc:
        return 'Global Rating ↑';
      case ExploreSortEnum.popularityDesc:
        return 'Popularity ↓';
      case ExploreSortEnum.watchlistFirst:
        return 'Watchlist';
    }
  }
}
