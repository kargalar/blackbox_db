import { ShowcaseContentModel } from '@/models/content';
import { ExploreSortEnum } from '@/enums/exploreSort';

const TMDB_API_KEY = import.meta.env.VITE_TMDB_API_KEY as string | undefined;
const TMDB_BASE = 'https://api.themoviedb.org/3';
const IMG = 'https://image.tmdb.org/t/p/w500';

export interface DiscoverParams {
  page?: number;
  with_genres?: string; // comma-separated ids
  with_original_language?: string;
  primary_release_date_gte?: string; // YYYY-MM-DD
  primary_release_date_lte?: string; // YYYY-MM-DD
  vote_average_gte?: number;
  sort_by?: ExploreSortEnum;
}

export interface Paged<T> {
  page: number;
  total_pages: number;
  total_results: number;
  results: T[];
}

interface TmdbMovie {
  id: number;
  title: string;
  overview?: string;
  poster_path?: string;
  backdrop_path?: string;
  popularity?: number;
  vote_average?: number;
  release_date?: string;
  original_language?: string;
}

export async function discoverMovies(params: DiscoverParams): Promise<Paged<ShowcaseContentModel>> {
  if (!TMDB_API_KEY) throw new Error('Missing VITE_TMDB_API_KEY');
  const url = new URL(`${TMDB_BASE}/discover/movie`);
  url.searchParams.set('api_key', TMDB_API_KEY);
  url.searchParams.set('include_adult', 'false');
  url.searchParams.set('language', 'en-US');
  if (params.page) url.searchParams.set('page', String(params.page));
  if (params.with_genres) url.searchParams.set('with_genres', params.with_genres);
  if (params.with_original_language) url.searchParams.set('with_original_language', params.with_original_language);
  if (params.primary_release_date_gte) url.searchParams.set('primary_release_date.gte', params.primary_release_date_gte);
  if (params.primary_release_date_lte) url.searchParams.set('primary_release_date.lte', params.primary_release_date_lte);
  if (params.vote_average_gte != null) url.searchParams.set('vote_average.gte', String(params.vote_average_gte));
  if (params.sort_by) url.searchParams.set('sort_by', params.sort_by);

  const res = await fetch(url.toString());
  if (!res.ok) throw new Error(`TMDB error ${res.status}`);
  const data = (await res.json()) as Paged<TmdbMovie>;
  return {
    page: data.page,
    total_pages: data.total_pages,
    total_results: data.total_results,
    results: data.results.map(mapMovie)
  };
}

function mapMovie(m: TmdbMovie): ShowcaseContentModel {
  const year = m.release_date ? new Date(m.release_date).getFullYear() : undefined;
  return {
    id: String(m.id),
    title: m.title,
    overview: m.overview,
    posterUrl: m.poster_path ? `${IMG}${m.poster_path}` : undefined,
    backdropUrl: m.backdrop_path ? `${IMG}${m.backdrop_path}` : undefined,
    contentType: 'movie',
    year,
    popularity: m.popularity,
    globalRating: m.vote_average,
    language: m.original_language
  };
}
