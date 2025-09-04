export type ContentType = 'movie' | 'game' | 'book';

export interface ShowcaseContentModel {
  id: string;
  title: string;
  overview?: string;
  posterUrl?: string;
  backdropUrl?: string;
  contentType: ContentType;
  year?: number;
  popularity?: number;
  globalRating?: number;
  rating?: number; // user avg
  language?: string;
}
