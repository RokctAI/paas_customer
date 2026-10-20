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

// The detail view of one wallet row (Ray, 2026-10-17, C8): the row's own
// facts (date, reference, type, amount, status) and, below them, whatever
// a home SDK adds through WalletHistoryPage.rowDetailBuilder - lms_sdk's
// billing record (student, plan, period) for a subscription payment. The
// pay schema is unchanged: the home SDK finds its record from the row.

import 'package:base_sdk/src/models/response/wallet_histories_response.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet_sdk/src/common/translations/wallet_translations.dart';

class WalletRowDetailSheet extends StatelessWidget {
  const WalletRowDetailSheet({super.key, required this.row, this.extra});

  final WalletData row;

  /// The home SDK's part (null: row facts only).
  final Widget? extra;

  static void show(
    BuildContext context,
    WalletData row,
    Widget? Function(BuildContext, WalletData)? builder,
  ) {
    Widget? extra;
    try {
      extra = builder?.call(context, row);
    } catch (e) {
      debugPrint('==> wallet row detail builder failed: $e');
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppStyle.surfaceFor(Theme.of(context).brightness),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => WalletRowDetailSheet(row: row, extra: extra),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = AppStyle.inkFor(brightness);
    final muted = AppStyle.secondaryInkFor(brightness);
    final when = DateTime.tryParse(row.createdAt ?? '')?.toLocal();
    Widget line(String label, String value) => Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110.w,
                child: Text(label,
                    style: AppStyle.interNormal(size: 13.sp, color: muted)),
              ),
              Expanded(
                child: Text(value,
                    style: AppStyle.interSemi(size: 13.sp, color: ink)),
              ),
            ],
          ),
        );
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 4.h,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppStyle.dragElement,
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
            16.verticalSpace,
            Text(
              AppHelpers.getTranslation(WalletTrKeys.transactionDetails),
              style: AppStyle.interSemi(size: 18.sp, color: ink),
            ),
            12.verticalSpace,
            Text(
              AppHelpers.numberFormat(number: row.price),
              style: AppStyle.interBold(size: 22.sp, color: ink),
            ),
            12.verticalSpace,
            if (when != null)
              line(
                AppHelpers.getTranslation(TrKeys.paymentDate),
                intl.DateFormat('MMM dd, yyyy h:mm a').format(when),
              ),
            if ((row.note ?? '').isNotEmpty) line(AppHelpers.getTranslation(WalletTrKeys.reference), row.note!),
            if ((row.type ?? '').isNotEmpty) line(AppHelpers.getTranslation(WalletTrKeys.transactionType), row.type!),
            if ((row.status ?? '').isNotEmpty) line(AppHelpers.getTranslation(WalletTrKeys.status), row.status!),
            if (extra != null) ...[
              Divider(color: AppStyle.strokeFor(brightness)),
              extra!,
            ],
          ],
        ),
      ),
    );
  }
}
