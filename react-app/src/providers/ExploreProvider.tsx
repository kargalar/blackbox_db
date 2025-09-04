import React, { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState } from 'react';
import { ShowcaseContentModel } from '@/models/content';
import { ExploreSortEnum } from '@/enums/exploreSort';
import { discoverMovies, type Paged } from '@/services/externalApiService';

type ExploreFilters = {
  yearFrom?: number;
  yearTo?: number;
  minRating?: number;
  genres?: string; // comma-separated tmdb genre ids
  language?: string; // iso 639-1
  sort: ExploreSortEnum;
};

type ExploreState = {
  items: ShowcaseContentModel[];
  page: number;
  totalPages: number;
  loading: boolean;
  error?: string;
  filters: ExploreFilters;
  setFilters: (p: Partial<ExploreFilters>) => void;
  setPage: (page: number) => void;
  refresh: () => void;
};

const ExploreCtx = createContext<ExploreState | undefined>(undefined);

export const ExploreProvider: React.FC<React.PropsWithChildren> = ({ children }: { children?: React.ReactNode }) => {
  const [items, setItems] = useState<ShowcaseContentModel[]>([]);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | undefined>();
  const [filters, setFiltersState] = useState<ExploreFilters>({
    sort: ExploreSortEnum.PopularityDesc
  });

  const abortRef = useRef<AbortController | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(undefined);
    abortRef.current?.abort();
    const ac = new AbortController();
    abortRef.current = ac;
    try {
      const params = {
        page,
        with_genres: filters.genres,
        with_original_language: filters.language,
        primary_release_date_gte: filters.yearFrom ? `${filters.yearFrom}-01-01` : undefined,
        primary_release_date_lte: filters.yearTo ? `${filters.yearTo}-12-31` : undefined,
        vote_average_gte: filters.minRating,
        sort_by: filters.sort
      } as const;
      const res: Paged<ShowcaseContentModel> = await discoverMovies(params);
      if (ac.signal.aborted) return;
      setItems(res.results);
      setTotalPages(Math.max(1, res.total_pages));
    } catch (e: any) {
      if (e?.name === 'AbortError') return;
      setError(e?.message ?? 'Unknown error');
      setItems([]);
      setTotalPages(1);
    } finally {
      setLoading(false);
    }
  }, [page, filters.genres, filters.language, filters.yearFrom, filters.yearTo, filters.minRating, filters.sort]);

  useEffect(() => {
    fetchData();
    return () => abortRef.current?.abort();
  }, [fetchData]);

  const setFilters = useCallback((p: Partial<ExploreFilters>) => {
    setFiltersState((old: ExploreFilters) => ({ ...old, ...p }));
    setPage(1);
  }, []);

  const value = useMemo<ExploreState>(
    () => ({ items, page, totalPages, loading, error, filters, setFilters, setPage, refresh: fetchData }),
    [items, page, totalPages, loading, error, filters, setFilters, fetchData]
  );

  return <ExploreCtx.Provider value={value}>{children}</ExploreCtx.Provider>;
};

export function useExplore() {
  const ctx = useContext(ExploreCtx);
  if (!ctx) throw new Error('useExplore must be used within ExploreProvider');
  return ctx;
}
