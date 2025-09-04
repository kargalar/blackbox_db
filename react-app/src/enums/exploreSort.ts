export enum ExploreSortEnum {
  PopularityDesc = 'popularity.desc',
  VoteAverageDesc = 'vote_average.desc',
  ReleaseDateDesc = 'primary_release_date.desc',
  TitleAsc = 'original_title.asc'
}

export const exploreSortLabels: Record<ExploreSortEnum, string> = {
  [ExploreSortEnum.PopularityDesc]: 'Popularity',
  [ExploreSortEnum.VoteAverageDesc]: 'Global Rating',
  [ExploreSortEnum.ReleaseDateDesc]: 'Latest Release',
  [ExploreSortEnum.TitleAsc]: 'Title (A-Z)'
};
