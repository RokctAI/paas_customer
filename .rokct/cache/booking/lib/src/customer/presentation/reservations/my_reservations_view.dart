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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/components/loading.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:booking_sdk/src/common/booking_routes.dart';
import 'package:booking_sdk/src/common/booking_tr_keys.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';
import 'package:booking_sdk/src/common/presentation/reservation_widgets.dart';
import 'package:booking_sdk/src/customer/application/my_reservations/my_reservations_provider.dart';

/// The customer's reservations (`/reservations`): what paas_customer used
/// to hand off to `{webUrl}/reservations` in a web view. Signed-out users
/// get the login gate; the bottom button starts a new reservation.
class MyReservationsView extends ConsumerStatefulWidget {
  const MyReservationsView({super.key});

  @override
  ConsumerState<MyReservationsView> createState() => _MyReservationsViewState();
}

class _MyReservationsViewState extends ConsumerState<MyReservationsView> {
  bool get _signedIn => LocalStorage.getToken().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_signedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(myReservationsProvider.notifier).fetch();
      });
    }
  }

  Future<void> _confirmCancel(ReservationData r) async {
    final isDark = LocalStorage.getAppThemeMode();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppStyle.mainBackDark : AppStyle.white,
        title: Text(
          AppHelpers.getTranslation(BookingTrKeys.cancelThisReservation),
          style: AppStyle.interSemi(
            size: 16,
            color: isDark ? AppStyle.white : AppStyle.black,
          ),
        ),
        content: Text(
          '${r.tableId}\n${reservationWhen(r)}',
          style: AppStyle.interNormal(size: 14, color: AppStyle.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppHelpers.getTranslation(TrKeys.back)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              AppHelpers.getTranslation(BookingTrKeys.cancelReservation),
              style: AppStyle.interSemi(size: 14, color: AppStyle.red),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final error = await ref.read(myReservationsProvider.notifier).cancel(r.id);
    if (!mounted) return;
    if (error == null) {
      AppHelpers.showCheckTopSnackBarDone(
        context,
        AppHelpers.getTranslation(BookingTrKeys.reservationCancelled),
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context, error);
    }
  }

  Future<void> _newReservation() async {
    await BookingRoutes.push(context, BookingRoutes.newReservation);
    if (mounted && _signedIn) {
      ref.read(myReservationsProvider.notifier).fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = LocalStorage.getAppThemeMode();
    final state = ref.watch(myReservationsProvider);

    Widget body;
    if (!_signedIn) {
      body = BookingMessage(
        isDark: isDark,
        text: AppHelpers.getTranslation(BookingTrKeys.logInToReserveATable),
        actionLabel: AppHelpers.getTranslation(TrKeys.login),
        onAction: () => AppRoutes.I.pushLoginRoute(context),
      );
    } else if (state.isLoading && state.reservations.isEmpty) {
      body = const Loading();
    } else if (state.reservations.isEmpty) {
      body = BookingMessage(
        isDark: isDark,
        text: state.error ??
            AppHelpers.getTranslation(BookingTrKeys.noReservationsYet),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: () => ref.read(myReservationsProvider.notifier).fetch(),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          itemCount: state.reservations.length,
          itemBuilder: (context, i) {
            final r = state.reservations[i];
            final upcoming =
                r.start != null && r.start!.isAfter(DateTime.now());
            final cancellable =
                r.status != ReservationStatus.cancelled && upcoming;
            return ReservationCard(
              reservation: r,
              isDark: isDark,
              actions: cancellable
                  ? Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: state.cancellingId == r.id
                            ? null
                            : () => _confirmCancel(r),
                        child: Text(
                          AppHelpers.getTranslation(
                              BookingTrKeys.cancelReservation),
                          style: AppStyle.interSemi(
                              size: 13, color: AppStyle.red),
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      );
    }

    return BookingScreen(
      isDark: isDark,
      title: AppHelpers.getTranslation(BookingTrKeys.myReservations),
      bottom: _signedIn
          ? CustomButton(
              title: AppHelpers.getTranslation(BookingTrKeys.reserveATable),
              background: AppStyle.primary,
              textColor: AppStyle.white,
              onPressed: _newReservation,
            )
          : null,
      child: body,
    );
  }
}
