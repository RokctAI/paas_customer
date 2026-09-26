## 1.3.0

* feat(demo): demo runs the real repositories through base_sdk's
  `DemoGatewayInterceptor` (requires base_sdk >= 1.73.0). The DI hooks
  register only the real repositories and register the
  `assets/demo/promotions` fixture directory; every platform cmd a demo session
  sends is answered from `templates/assets/demo/promotions/<cmd>.json`, and an
  unknown cmd fails loudly with `DemoFixtureMissing`.
* Removed: `MockBannersRepository`, and the demo-session swap code that
  chose them.

## 1.2.3

* fix(theme): surfaces, cards, ink and strokes now follow the app's light/dark
  mode instead of hardcoded light colours or static theme reads.

## 1.2.2

* fix: StoryListRoute re-exports RefreshController for generated routers;
  story_page drops const on AppStyle.primary (getter since core #105) —
  unblocks paas_manager Guided Tour build.

## 1.2.1

* Demo seed data (`--dart-define=IS_DEMO=true`), `MockBannersRepository`:
  the banner artwork is base_sdk's inline `DemoImages.promoBanner` instead
  of a public placeholder host a demo build cannot reach (the home carousel
  captured as a broken-image glyph), and the seeded campaign reads
  "Weeknight deals" / "Up to 50% off at kitchens near you" instead of "Demo
  Offer". The banner's shop is "Nonna's Pizzeria", matching merchants_sdk's
  second demo shop.

## 1.2.0

* Fix-wave 2026-09-02 (Dart SDK audit, G6 M28): `/storyList` (StoryListRoute)
  is declared in the manifest with a shell in
  `templates/routes/promotions_route_pages.dart` (installed to
  `lib/presentation/routes/`), and base_sdk's `pushStoryListRoute` seam is
  filled. The `?index=` deep link resolves via @QueryParam; a route pushed
  without the caller's pull-to-refresh controller gets its own inert one.
* Tests: `test/manifest_wiring_test.dart`.

## 1.1.1

* (no changelog was kept before this file; see git history)

