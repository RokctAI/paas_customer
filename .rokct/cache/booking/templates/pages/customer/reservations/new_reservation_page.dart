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

// Host-side route shell for booking_sdk's customer reservation flow
// (/new-reservation). `?shopId=<Shop docname>` pre-selects the shop, so a
// shop page can deep-link into the flow with
// `context.router.pushNamed('/new-reservation?shopId=$id')`.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:booking_sdk/src/customer/presentation/reservations/new_reservation_view.dart';

@RoutePage(name: 'NewReservationRoute')
class NewReservationPage extends StatelessWidget {
  final String? shopId;

  const NewReservationPage({
    super.key,
    @QueryParam('shopId') this.shopId,
  });

  @override
  Widget build(BuildContext context) => NewReservationView(shopId: shopId);
}
