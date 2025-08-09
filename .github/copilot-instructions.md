# Copilot Instructions for blackbox_db

This repo is a Flutter app for an archive/social platform (movies, books, games) with a local provider layer and external services (TMDB, IGDB, Supabase). Use this guide to work effectively in this codebase.

## Architecture
- UI pages in `lib/3_Page/**` compose widgets from `lib/3_Page/.../Widget/**` and common components in `lib/2_General/**`.
- State management uses a singleton Provider pattern (see `lib/6_Provider/**`), e.g., `ExploreProvider` with `factory ExploreProvider() => _instance;` and `ChangeNotifier`.
- Domain models live in `lib/8_Model/**` (e.g., `ShowcaseContentModel`), mapped from both external APIs and Supabase rows.
- Services
  - External integrations in `lib/5_Service/external_api_service.dart` (TMDB/IGDB). TMDB discover: `discoverMovies`, IGDB: `discoverGames`.
  - Supabase access in `lib/5_Service/migration_service.dart` (user content logs, averages, RPCs). Prefer aggregation helpers like `getAverageRatingsForContentIds`.
- Enums and app-wide types in `lib/7_Enum/**` (e.g., `ContentTypeEnum`, `ShowcaseTypeEnum`, `ExploreSortEnum`).

## Explore flow (key for productivity)
- Page: `lib/3_Page/Explore/explore_page.dart` renders
  - `ContentList` (grid of `ShowcaseContentModel`)
  - `ExploreFilter` (genre, language, year, min rating)
  - Pagination (`ExplorePagination`) and top-level sort dropdown.
- Data source logic: `ExploreProvider.getContent` decides between profile mode (Supabase via `MigrationService.getUserContents`) and explore mode (TMDB/IGDB via `ExternalApiService`).
- Sorting/filters:
  - Filters kept in `ExploreProvider` (yearFrom/To, minRating, genreFilteredList, languageFilter, sort).
  - Global sort for TMDB fields uses `discoverMovies(sort_by: ...)` with server-side sort for `vote_average`, `popularity`, `primary_release_date`.
  - Global user-rating sort aggregates multiple TMDB pages client-side (config: `_aggregateMaxPages`), fetches Supabase averages via `getAverageRatingsForContentIds`, sorts, then slices to current page.

## Patterns and conventions
- Providers are singletons; update state and call `notifyListeners()`. Avoid creating new provider instances—always use `context.watch/read<ExploreProvider>()`.
- Models accept mixed sources: when mapping API → model, fill shared fields; extra fields (`year`, `popularity`, `globalRating`, `rating` as user-avg) are optional.
- When adding filters/sort:
  - Add enum to `lib/7_Enum/*` with `.label` extension if needed.
  - Extend provider: input state, wire into `getContent`, pass remote sort (TMDB) when possible; otherwise apply local/global aggregation.
  - Update UI in `explore_page.dart` to expose options.
- Use `MigrationService` views like `latest_user_content_log` and helpers to ensure correct user scoping and efficient aggregation.

## External APIs
- TMDB: base headers in `external_api_service.dart`; Discover endpoint builds URL with optional `with_genres`, `with_original_language`, `primary_release_date.gte/lte`, `sort_by`.
- IGDB: POST queries with a simple filter DSL; results enhanced with user logs by an additional Supabase join (through MigrationService helper `_getUserLogsForContents`).
- Supabase: SQL-like access via PostgREST. Prefer existing RPCs/views when available; if missing, add helpers in `migration_service.dart`.

## Dev workflows
- Build/run Flutter app with standard tooling (Android Studio/VS Code). This repo includes `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/` targets.
- Tests live in `test/`. Keep widget tests lightweight; use `unit_test_assets` for assets.
- When you add new models/fields used in UI, ensure conversions in providers are updated and compile with `flutter analyze`.

## Gotchas
- Explore sorting: default sorts only within fetched page unless explicitly aggregated or using remote sort. For user-rating global sort, use the built-in aggregation cache (`_aggregatedUserRatingList`).
- Ratings semantics: `ShowcaseContentModel.rating` is user-specific average (from Supabase) in explore context; `globalRating` (TMDB/IGDB) is separate.
- Year extraction: Movies use `release_date`; Games use epoch `first_release_date` (convert seconds → DateTime).
- Avoid re-instantiating providers; they’re singletons with internal state (filters, paging). Reset/clear caches when changing sort to avoid stale data.

## Where to look
- Explore UI: `lib/3_Page/Explore/**`
- Provider logic: `lib/6_Provider/explore_provider.dart`
- External services: `lib/5_Service/external_api_service.dart`
- Supabase service: `lib/5_Service/migration_service.dart`
- Models: `lib/8_Model/**`

## Example: Adding a new sort
1. Add enum in `lib/7_Enum/explore_sort_enum.dart` with a `label`.
2. In `ExploreProvider.getContent`, map the sort to either TMDB `sort_by` (remote) or local/global sort. If global on user data, aggregate multiple pages and use `getAverageRatingsForContentIds`.
3. Expose in `explore_page.dart` dropdown and trigger `provider.getContent` on change.
