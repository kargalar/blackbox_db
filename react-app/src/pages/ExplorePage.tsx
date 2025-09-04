import { useExplore } from '@/providers/ExploreProvider';
import { exploreSortLabels, ExploreSortEnum } from '@/enums/exploreSort';

export function ExplorePage() {
  const { items, page, totalPages, loading, error, filters, setFilters, setPage } = useExplore();
  return (
    <div className="container">
      <header className="topbar">
        <h1>Explore Movies</h1>
        <div className="filters">
          <label>
            Sort
            <select
              value={filters.sort}
              onChange={(e) => setFilters({ sort: e.target.value as ExploreSortEnum })}
            >
              {Object.values(ExploreSortEnum).map((k) => (
                <option key={k} value={k}>
                  {exploreSortLabels[k]}
                </option>
              ))}
            </select>
          </label>
          <label>
            Language
            <input
              placeholder="en"
              value={filters.language ?? ''}
              onChange={(e) => setFilters({ language: e.target.value || undefined })}
            />
          </label>
          <label>
            Min rating
            <input
              type="number"
              min={0}
              max={10}
              step={0.5}
              value={filters.minRating ?? ''}
              onChange={(e) => setFilters({ minRating: e.target.value ? Number(e.target.value) : undefined })}
            />
          </label>
          <label>
            Year from
            <input
              type="number"
              min={1900}
              max={2100}
              value={filters.yearFrom ?? ''}
              onChange={(e) => setFilters({ yearFrom: e.target.value ? Number(e.target.value) : undefined })}
            />
          </label>
          <label>
            Year to
            <input
              type="number"
              min={1900}
              max={2100}
              value={filters.yearTo ?? ''}
              onChange={(e) => setFilters({ yearTo: e.target.value ? Number(e.target.value) : undefined })}
            />
          </label>
        </div>
      </header>
      {error && <div className="error">{error}</div>}
      {loading ? (
        <div className="loading">Loading…</div>
      ) : (
        <div className="grid">
          {items.map((it) => (
            <article key={it.id} className="card">
              {it.posterUrl && <img src={it.posterUrl} alt={it.title} />}
              <div className="content">
                <h3>{it.title}</h3>
                <p className="muted">
                  {it.year ?? '—'} · {it.language?.toUpperCase() ?? '—'} · ⭐ {it.globalRating?.toFixed(1) ?? '—'}
                </p>
                {it.overview && <p className="overview">{it.overview}</p>}
              </div>
            </article>
          ))}
        </div>
      )}
      <footer className="pagination">
        <button disabled={page <= 1} onClick={() => setPage(page - 1)}>
          Prev
        </button>
        <span>
          Page {page} / {totalPages}
        </span>
        <button disabled={page >= totalPages} onClick={() => setPage(page + 1)}>
          Next
        </button>
      </footer>
    </div>
  );
}
