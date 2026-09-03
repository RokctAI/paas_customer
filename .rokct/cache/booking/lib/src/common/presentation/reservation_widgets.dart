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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

import 'package:base_sdk/src/presentation/components/app_bars/common_app_bar.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/components/buttons/pop_button.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:booking_sdk/src/common/booking_tr_keys.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';

/// Small shared pieces for the reservation screens (both roles): the
/// status pill, the reservation card and the selectable chip.

Color reservationStatusColor(ReservationStatus status) => switch (status) {
      ReservationStatus.newStatus => AppStyle.pendingDark,
      ReservationStatus.accepted => AppStyle.green,
      ReservationStatus.cancelled => AppStyle.red,
    };

String reservationStatusLabel(ReservationStatus status) =>
    AppHelpers.getTranslation(switch (status) {
      ReservationStatus.newStatus => BookingTrKeys.reservationStatusNew,
      ReservationStatus.accepted => BookingTrKeys.reservationStatusAccepted,
      ReservationStatus.cancelled => BookingTrKeys.reservationStatusCancelled,
    });

String reservationWhen(ReservationData r) {
  final start = r.start;
  if (start == null) return '';
  final day = DateFormat('EEE, d MMM').format(start);
  final from = DateFormat('HH:mm').format(start);
  final end = r.end;
  return end == null
      ? '$day  $from'
      : '$day  $from - ${DateFormat('HH:mm').format(end)}';
}

class ReservationStatusPill extends StatelessWidget {
  final ReservationStatus status;

  const ReservationStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = reservationStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        reservationStatusLabel(status),
        style: AppStyle.interSemi(size: 12, color: color),
      ),
    );
  }
}

/// One reservation: table, when, guests, note, status, and an optional
/// trailing action row (customer: cancel; manager: status buttons).
class ReservationCard extends StatelessWidget {
  final ReservationData reservation;
  final bool isDark;

  /// Manager list shows who reserved; the customer list does not.
  final bool showUser;
  final Widget? actions;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.isDark,
    this.showUser = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final textColor = isDark ? AppStyle.white : AppStyle.black;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppStyle.bottomNavigationBarColor : AppStyle.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppStyle.borderDark : AppStyle.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Remix.reserved_line, size: 20.r, color: AppStyle.primary),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  r.tableId,
                  style: AppStyle.interSemi(size: 16, color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ReservationStatusPill(status: r.status),
            ],
          ),
          8.verticalSpace,
          _line(Remix.calendar_event_line, reservationWhen(r)),
          if (r.guestCount > 0)
            _line(
              Remix.group_line,
              '${AppHelpers.getTranslation(BookingTrKeys.reservationGuests)}: '
              '${r.guestCount}',
            ),
          if (showUser && (r.user ?? '').isNotEmpty)
            _line(
              Remix.user_line,
              '${AppHelpers.getTranslation(BookingTrKeys.reservedFor)}: '
              '${r.user}',
            ),
          if ((r.note ?? '').trim().isNotEmpty)
            _line(Remix.chat_1_line, r.note!.trim()),
          if (actions != null) ...[10.verticalSpace, actions!],
        ],
      ),
    );
  }

  Widget _line(IconData icon, String text) => Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16.r, color: AppStyle.textGrey),
            6.horizontalSpace,
            Expanded(
              child: Text(
                text,
                style: AppStyle.interNormal(size: 13, color: AppStyle.textGrey),
              ),
            ),
          ],
        ),
      );
}

/// A selectable chip: sections, tables, days, times, durations.
class BookingChip extends StatelessWidget {
  final String label;
  final String? caption;
  final bool selected;
  final bool enabled;
  final bool isDark;
  final VoidCallback? onTap;

  const BookingChip({
    super.key,
    required this.label,
    required this.selected,
    required this.isDark,
    this.caption,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = !enabled
        ? AppStyle.textGrey.withValues(alpha: 0.5)
        : selected
            ? AppStyle.white
            : (isDark ? AppStyle.white : AppStyle.black);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? AppStyle.primary
              : (isDark ? AppStyle.bottomNavigationBarColor : AppStyle.bgGrey),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected
                ? AppStyle.primary
                : (isDark ? AppStyle.borderDark : AppStyle.borderColor),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppStyle.interSemi(size: 13, color: fg)),
            if (caption != null)
              Text(
                caption!,
                style: AppStyle.interNormal(
                  size: 11,
                  color: selected ? AppStyle.white : AppStyle.textGrey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Section heading inside the flow.
class BookingStepTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const BookingStepTitle({super.key, required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 18.h, bottom: 10.h),
        child: Text(
          title,
          style: AppStyle.interSemi(
            size: 15,
            color: isDark ? AppStyle.white : AppStyle.black,
          ),
        ),
      );
}

/// A screen frame shared by every booking page: mode-aware background,
/// base_sdk's CommonAppBar with the back button and title, then [child].
class BookingScreen extends StatelessWidget {
  final String title;
  final bool isDark;
  final Widget child;
  final Widget? bottom;

  const BookingScreen({
    super.key,
    required this.title,
    required this.isDark,
    required this.child,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppStyle.mainBackDark : AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Row(
              children: [
                const PopButton(),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: AppStyle.interSemi(
                      size: 18,
                      color: isDark ? AppStyle.white : AppStyle.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
          if (bottom != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                8.h,
                16.w,
                MediaQuery.paddingOf(context).bottom + 16.h,
              ),
              child: bottom,
            ),
        ],
      ),
    );
  }
}

/// Centered empty / error / gate message with an optional action.
class BookingMessage extends StatelessWidget {
  final String text;
  final bool isDark;
  final String? actionLabel;
  final VoidCallback? onAction;

  const BookingMessage({
    super.key,
    required this.text,
    required this.isDark,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Remix.reserved_line, size: 40.r, color: AppStyle.textGrey),
              12.verticalSpace,
              Text(
                text,
                textAlign: TextAlign.center,
                style: AppStyle.interNormal(size: 14, color: AppStyle.textGrey),
              ),
              if (actionLabel != null) ...[
                16.verticalSpace,
                CustomButton(
                  title: actionLabel!,
                  background: AppStyle.primary,
                  textColor: AppStyle.white,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      );
}
