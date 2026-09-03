// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.


// Host composition file (ADR-005): thin @RoutePage shell for promotions_sdk's
// story viewer. auto_route's codegen only generates route classes for
// @RoutePage widgets that live in the HOST's own lib/, so the manifest's
// "routes" entry points at THIS file (installed to lib/presentation/routes/)
// - the same pattern as marketplace_sdk's marketplace_route_pages.dart.
//
// Route name and path are the pre-fork paas_customer ones (fix-wave
// 2026-09-02 route map, row 17) so the `/storyList?index=<n>` deep links
// and base_sdk's AppRoutes `pushStoryListRoute` seam (filled by this SDK's
// manifest "app_routes") keep working. Declared top-level: this manifest has
// no flavour blocks and promotions_sdk composes only into customer-family
// apps.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// Re-exported (not just imported): the generated app_router.gr.dart is a
// `part` of app_router.dart and shares its library scope, and
// StoryListRouteArgs references RefreshController by type - it has to be
// visible there, not just inside this file (same pattern as auth_sdk's
// UserModel and map_sdk's AddressNewModel re-exports).
export 'package:pull_to_refresh/pull_to_refresh.dart' show RefreshController;

import 'package:promotions_sdk/src/common/presentation/pages/story_page/story_page.dart';

/// `/storyList` - the full-screen story viewer opened from a home story
/// bar tile. `index` is the tile's position; the pull-to-refresh
/// `controller` is the home list's, handed over so closing the last story
/// refreshes the bar (a route without one gets its own inert controller).
@RoutePage(name: 'StoryListRoute')
class StoryListRouteView extends StatefulWidget {
  final int index;
  final RefreshController? controller;

  const StoryListRouteView({
    super.key,
    @QueryParam('index') this.index = 0,
    this.controller,
  });

  @override
  State<StoryListRouteView> createState() => _StoryListRouteViewState();
}

class _StoryListRouteViewState extends State<StoryListRouteView> {
  RefreshController? _ownController;

  RefreshController get _controller =>
      widget.controller ?? (_ownController ??= RefreshController());

  @override
  void dispose() {
    _ownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      StoryListPage(index: widget.index, controller: _controller);
}
