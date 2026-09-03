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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';
import 'package:base_sdk/src/presentation/components/loading.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:booking_sdk/src/common/booking_tr_keys.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';
import 'package:booking_sdk/src/common/presentation/reservation_widgets.dart';
import 'package:booking_sdk/src/common/utils/booking_schedule_rules.dart';
import 'package:booking_sdk/src/customer/application/reservation_flow/reservation_flow_provider.dart';

/// `/new-reservation`: shop -> section -> table -> day / time / duration /
/// guests / note -> confirm, on one scrolling page that reveals each step
/// as the previous one is answered. [shopId] (the `?shopId=` query
/// parameter) skips the shop step.
class NewReservationView extends ConsumerStatefulWidget {
  final String? shopId;

  const NewReservationView({super.key, this.shopId});

  @override
  ConsumerState<NewReservationView> createState() => _NewReservationViewState();
}

class _NewReservationViewState extends ConsumerState<NewReservationView> {
  final _note = TextEditingController();

  bool get _signedIn => LocalStorage.getToken().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_signedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(reservationFlowProvider.notifier)
              .init(shopId: widget.shopId);
        }
      });
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final notifier = ref.read(reservationFlowProvider.notifier);
    notifier.setNote(_note.text);
    final error = await notifier.submit();
    if (!mounted) return;
    if (error == null) {
      AppHelpers.showCheckTopSnackBarDone(
        context,
        AppHelpers.getTranslation(BookingTrKeys.reservationCreated),
      );
      context.router.maybePop(true);
    } else {
      AppHelpers.showCheckTopSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = LocalStorage.getAppThemeMode();
    final state = ref.watch(reservationFlowProvider);
    final notifier = ref.read(reservationFlowProvider.notifier);
    final textColor = isDark ? AppStyle.white : AppStyle.black;

    if (!_signedIn) {
      return BookingScreen(
        isDark: isDark,
        title: AppHelpers.getTranslation(BookingTrKeys.newReservation),
        child: BookingMessage(
          isDark: isDark,
          text: AppHelpers.getTranslation(BookingTrKeys.logInToReserveATable),
          actionLabel: AppHelpers.getTranslation(TrKeys.login),
          onAction: () => AppRoutes.I.pushLoginRoute(context),
        ),
      );
    }

    final children = <Widget>[];

    // 1. Shop.
    if (state.shop == null) {
      children.add(BookingStepTitle(
        isDark: isDark,
        title: AppHelpers.getTranslation(BookingTrKeys.chooseAShop),
      ));
      if (state.loadingShops && state.shops.isEmpty) {
        children.add(const Padding(
          padding: EdgeInsets.all(24),
          child: Loading(),
        ));
      } else if (state.shops.isEmpty) {
        children.add(BookingMessage(
          isDark: isDark,
          text: state.error ?? AppHelpers.getTranslation(TrKeys.noData),
        ));
      } else {
        for (final shop in state.shops) {
          children.add(_ShopRow(
            shop: shop,
            isDark: isDark,
            onTap: () => notifier.selectShop(shop),
          ));
        }
        if (state.hasMoreShops) {
          children.add(Center(
            child: TextButton(
              onPressed: state.loadingShops ? null : notifier.loadMoreShops,
              child: Text(
                AppHelpers.getTranslation(TrKeys.next),
                style: AppStyle.interSemi(size: 13, color: AppStyle.primary),
              ),
            ),
          ));
        }
      }
    } else {
      children.add(_ShopRow(
        shop: state.shop!,
        isDark: isDark,
        selected: true,
        onTap: widget.shopId == null ? notifier.clearShop : null,
      ));

      if (state.loadingShop) {
        children.add(const Padding(
          padding: EdgeInsets.all(24),
          child: Loading(),
        ));
      } else if (state.shopNotTakingReservations) {
        children.add(BookingMessage(
          isDark: isDark,
          text: AppHelpers.getTranslation(
              BookingTrKeys.shopNotTakingReservationsYet),
        ));
      } else {
        // 2. Section.
        children.add(BookingStepTitle(
          isDark: isDark,
          title: AppHelpers.getTranslation(BookingTrKeys.chooseASection),
        ));
        if (state.sections.isEmpty) {
          children.add(_hint(
              AppHelpers.getTranslation(BookingTrKeys.noSectionsYet)));
        } else {
          children.add(Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final s in state.sections)
                BookingChip(
                  label: s.title,
                  isDark: isDark,
                  selected: state.section?.id == s.id,
                  onTap: () => notifier.selectSection(s),
                ),
            ],
          ));
        }

        // 3. Table.
        if (state.section != null) {
          children.add(BookingStepTitle(
            isDark: isDark,
            title: AppHelpers.getTranslation(BookingTrKeys.chooseATable),
          ));
          if (state.loadingTables) {
            children.add(const Padding(
              padding: EdgeInsets.all(16),
              child: Loading(),
            ));
          } else if (state.tables.isEmpty) {
            children.add(
                _hint(AppHelpers.getTranslation(BookingTrKeys.noTablesYet)));
          } else {
            children.add(Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final t in state.tables)
                  BookingChip(
                    label: t.id,
                    caption: t.chairCount > 0
                        ? '${t.chairCount} '
                            '${AppHelpers.getTranslation(BookingTrKeys.reservationSeats)}'
                        : null,
                    isDark: isDark,
                    selected: state.table?.id == t.id,
                    onTap: () => notifier.selectTable(t),
                  ),
              ],
            ));
          }
        }

        // 4. Day, time, duration, guests, note.
        if (state.table != null) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          children.add(BookingStepTitle(
            isDark: isDark,
            title: AppHelpers.getTranslation(BookingTrKeys.reservationDate),
          ));
          children.add(SizedBox(
            height: 64.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              separatorBuilder: (_, __) => 8.horizontalSpace,
              itemBuilder: (context, i) {
                final day = today.add(Duration(days: i));
                return BookingChip(
                  label: DateFormat('EEE').format(day),
                  caption: DateFormat('d MMM').format(day),
                  isDark: isDark,
                  selected: isSameDay(state.day, day),
                  enabled: isDayBookable(day: day, schedule: state.schedule),
                  onTap: () => notifier.selectDay(day),
                );
              },
            ),
          ));

          final starts = state.startOptions(now);
          children.add(BookingStepTitle(
            isDark: isDark,
            title: AppHelpers.getTranslation(BookingTrKeys.reservationTime),
          ));
          if (starts.isEmpty) {
            children.add(_hint(AppHelpers.getTranslation(
                BookingTrKeys.noTimesLeftOnThisDay)));
          } else {
            children.add(Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final t in starts)
                  BookingChip(
                    label: DateFormat('HH:mm').format(t),
                    isDark: isDark,
                    selected: state.start == t,
                    onTap: () => notifier.selectStart(t),
                  ),
              ],
            ));
          }

          children.add(BookingStepTitle(
            isDark: isDark,
            title: AppHelpers.getTranslation(TrKeys.duration),
          ));
          children.add(Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final d in state.durationChoices)
                BookingChip(
                  label: _durationLabel(d),
                  isDark: isDark,
                  selected: state.durationMinutes == d,
                  onTap: () => notifier.selectDuration(d),
                ),
            ],
          ));

          children.add(BookingStepTitle(
            isDark: isDark,
            title: AppHelpers.getTranslation(BookingTrKeys.reservationGuests),
          ));
          children.add(Row(
            children: [
              _RoundIcon(
                icon: Remix.subtract_line,
                isDark: isDark,
                onTap: () => notifier.setGuests(state.guests - 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  '${state.guests}',
                  style: AppStyle.interSemi(size: 18, color: textColor),
                ),
              ),
              _RoundIcon(
                icon: Remix.add_line,
                isDark: isDark,
                onTap: () => notifier.setGuests(state.guests + 1),
              ),
              if ((state.table?.chairCount ?? 0) > 0) ...[
                12.horizontalSpace,
                Text(
                  '${AppHelpers.getTranslation(BookingTrKeys.reservationSeats)}: '
                  '${state.table!.chairCount}',
                  style: AppStyle.interNormal(size: 13, color: AppStyle.textGrey),
                ),
              ],
            ],
          ));

          children.add(BookingStepTitle(
            isDark: isDark,
            title: AppHelpers.getTranslation(BookingTrKeys.reservationNote),
          ));
          children.add(TextField(
            controller: _note,
            maxLines: 3,
            style: AppStyle.interNormal(size: 14, color: textColor),
            decoration: InputDecoration(
              hintText: AppHelpers.getTranslation(TrKeys.note),
              hintStyle:
                  AppStyle.interNormal(size: 14, color: AppStyle.textGrey),
              filled: true,
              fillColor: isDark
                  ? AppStyle.bottomNavigationBarColor
                  : AppStyle.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? AppStyle.borderDark : AppStyle.borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? AppStyle.borderDark : AppStyle.borderColor,
                ),
              ),
            ),
          ));
        }
      }
      if (state.error != null && !state.loadingShop) {
        children.add(Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text(
            state.error!,
            style: AppStyle.interNormal(size: 13, color: AppStyle.red),
          ),
        ));
      }
    }

    return BookingScreen(
      isDark: isDark,
      title: AppHelpers.getTranslation(BookingTrKeys.newReservation),
      bottom: state.shop != null && !state.shopNotTakingReservations
          ? CustomButton(
              title: AppHelpers.getTranslation(BookingTrKeys.confirmReservation),
              background: AppStyle.primary,
              textColor: AppStyle.white,
              isLoading: state.isSubmitting,
              onPressed: state.canSubmit ? _submit : null,
            )
          : null,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
        children: children,
      ),
    );
  }

  Widget _hint(String text) => Text(
        text,
        style: AppStyle.interNormal(size: 13, color: AppStyle.textGrey),
      );

  String _durationLabel(int minutes) {
    if (minutes % 60 == 0) return '${minutes ~/ 60} h';
    if (minutes > 60) return '${minutes ~/ 60} h ${minutes % 60} min';
    return '$minutes min';
  }
}

class _ShopRow extends StatelessWidget {
  final ShopData shop;
  final bool isDark;
  final bool selected;
  final VoidCallback? onTap;

  const _ShopRow({
    required this.shop,
    required this.isDark,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppStyle.bottomNavigationBarColor : AppStyle.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected
                ? AppStyle.primary
                : (isDark ? AppStyle.borderDark : AppStyle.borderColor),
          ),
        ),
        child: Row(
          children: [
            CustomNetworkImage(
              url: shop.logoImg,
              height: 44.r,
              width: 44.r,
              radius: 10.r,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                shop.translation?.title ?? shop.id ?? '',
                style: AppStyle.interSemi(
                  size: 15,
                  color: isDark ? AppStyle.white : AppStyle.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              selected ? Remix.edit_line : Remix.arrow_right_s_line,
              size: 20.r,
              color: AppStyle.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _RoundIcon({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isDark ? AppStyle.bottomNavigationBarColor : AppStyle.white,
            border: Border.all(
              color: isDark ? AppStyle.borderDark : AppStyle.borderColor,
            ),
          ),
          child: Icon(
            icon,
            size: 20.r,
            color: isDark ? AppStyle.white : AppStyle.black,
          ),
        ),
      );
}
