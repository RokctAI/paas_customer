import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:intl/intl.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/application/order/order_state.dart';
import 'package:foodyman/application/order_time/time_state.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/application/order_time/time_notifier.dart';
import 'package:foodyman/application/order_time/time_provider.dart';

import 'package:foodyman/presentation/components/components.dart';

class TimeDelivery extends ConsumerStatefulWidget {
  final CustomColorSet colors;
  const TimeDelivery({super.key, required this.colors});

  @override
  ConsumerState<TimeDelivery> createState() => _TimeDeliveryState();
}

class _TimeDeliveryState extends ConsumerState<TimeDelivery>
    with TickerProviderStateMixin {
  late TimeNotifier event;
  late TimeState state;

  late OrderState stateOrder;
  late TabController _tabController;
  final _tabs = [
    Tab(text: AppHelpers.getTranslation(TrKeys.today)),
    Tab(text: AppHelpers.getTranslation(TrKeys.tomorrow)),
  ];

  Iterable list = [];

  bool? isCheckCloseDay(String? dateFormat) {
    DateTime date = DateFormat("EEEE, MMM dd").parse(dateFormat ?? "");
    return ref
        .read(orderProvider)
        .shopData
        ?.shopClosedDate
        ?.map((e) => e.day!.day)
        .contains(date.day);
  }

  @override
  void initState() {
    for (int i = 0; i < 5; i++) {
      _tabs.add(
        Tab(
          text: AppHelpers.getTranslation(
            TimeService.dateFormatEMD(
              DateTime.now().add(Duration(days: i + 2)),
            ),
          ),
        ),
      );
    }
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: ref.read(orderProvider).todayTimes.isNotEmpty ? 0 : 1,
    );
    list = [
      "${AppHelpers.getTranslation(TrKeys.today)} — ${ref.read(orderProvider).shopData?.deliveryTime?.to ?? 40} ${AppHelpers.getTranslation(TrKeys.min)}",
      AppHelpers.getTranslation(TrKeys.other),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timeProvider.notifier).reset();
      ref.read(orderProvider.notifier).checkWorkingDay();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(timeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stateOrder = ref.watch(orderProvider);
    state = ref.watch(timeProvider);
    return Container(
      decoration: BoxDecoration(
        color: widget.colors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, -5.h),
            spreadRadius: 0,
          ),
        ],
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            Center(
              child: Container(
                height: 5.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: AppStyle.textGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.all(Radius.circular(100.r)),
                ),
              ),
            ),
            20.verticalSpace,
            TitleAndIcon(
              title: state.currentIndexOne == 0
                  ? AppHelpers.getTranslation(TrKeys.deliveryTime)
                  : AppHelpers.getTranslation(TrKeys.timeSchedule),
              paddingHorizontalSize: 0,
              titleSize: 20,
              rightTitle: state.currentIndexOne == 0
                  ? ""
                  : AppHelpers.getTranslation(TrKeys.clear),
              rightTitleColor: AppStyle.red,
              onRightTap: state.currentIndexOne == 0
                  ? () {}
                  : () => event.changeOne(0),
            ),
            20.verticalSpace,
            state.currentIndexOne == 0 && stateOrder.todayTimes.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return SelectItem(
                        onTap: () => event.changeOne(index),
                        isActive: state.currentIndexOne == index,
                        title: list.elementAt(index),
                      );
                    },
                  )
                : Expanded(
                    child: Column(
                      children: [
                        CustomTabBar(
                          isScrollable: true,
                          tabController: _tabController,
                          tabs: _tabs,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              stateOrder.todayTimes.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.only(
                                        top: 24.h,
                                        bottom: 16.h,
                                      ),
                                      itemCount: stateOrder.todayTimes.length,
                                      itemBuilder: (context, index) {
                                        return SelectItem(
                                          onTap: () {
                                            event.selectIndex(index);
                                            ref
                                                .read(orderProvider.notifier)
                                                .setTimeAndDay(
                                                  stateOrder
                                                      .todayTimes[index]
                                                      .toNextTime,
                                                  DateTime.now(),
                                                );
                                          },
                                          isActive: state.selectIndex == index,
                                          title: stateOrder.todayTimes
                                              .elementAt(index)
                                              .toTime,
                                        );
                                      },
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.r,
                                        vertical: 48.r,
                                      ),
                                      child: Text(
                                        AppHelpers.getTranslation(
                                          TrKeys.notWorkToday,
                                        ),
                                        style: AppStyle.interNormal(size: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                              ...List.generate(stateOrder.dailyTimes.length, (
                                indexTab,
                              ) {
                                return stateOrder.dailyTimes[indexTab].isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32.r,
                                          vertical: 48.r,
                                        ),
                                        child: Text(
                                          "${AppHelpers.getTranslation(TrKeys.notWork)} ${_tabs[indexTab + 1].text}",
                                          style: AppStyle.interNormal(size: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.only(
                                          top: 24.h,
                                          bottom: 16.h,
                                        ),
                                        itemCount: stateOrder
                                            .dailyTimes[indexTab]
                                            .length,
                                        itemBuilder: (context, index) {
                                          return SelectItem(
                                            onTap: () {
                                              DateTime day = indexTab == 0
                                                  ? DateTime.now().add(
                                                      Duration(days: 1),
                                                    )
                                                  : DateFormat(
                                                      "EEEE, MMM dd",
                                                    ).parse(
                                                      _tabs[indexTab + 1]
                                                              .text ??
                                                          "",
                                                    );
                                              event.selectIndex(index);
                                              ref
                                                  .read(orderProvider.notifier)
                                                  .setTimeAndDay(
                                                    stateOrder
                                                        .dailyTimes[indexTab][index]
                                                        .toNextTime,
                                                    day,
                                                  );
                                            },
                                            isActive:
                                                state.selectIndex == index,
                                            title: stateOrder
                                                .dailyTimes[indexTab]
                                                .elementAt(index)
                                                .toTime,
                                          );
                                        },
                                      );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
