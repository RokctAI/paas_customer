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

// Host-side route shell for booking_sdk's customer "My reservations"
// screen. auto_route's generator only scans the host package, so the
// SDK-resident view is wrapped in a thin @RoutePage here (marketplace_sdk's
// marketplace_route_pages.dart pattern); manifest.json's
// app_type.customer route maps /reservations to ReservationsRoute.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:booking_sdk/src/customer/presentation/reservations/my_reservations_view.dart';

@RoutePage(name: 'ReservationsRoute')
class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) => const MyReservationsView();
}
