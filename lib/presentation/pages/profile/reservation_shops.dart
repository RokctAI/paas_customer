import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/select/select_provider.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class ReservationShops extends ConsumerStatefulWidget {
  final CustomColorSet colors;

  const ReservationShops({super.key, required this.colors});

  @override
  ConsumerState<ReservationShops> createState() => _ReservationShopsState();
}

class _ReservationShopsState extends ConsumerState<ReservationShops> {
  final RefreshController _recommendedController = RefreshController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).fetchShop(context);
      ref.read(selectProvider.notifier).selectIndex(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(homeProvider.notifier);
    final state = ref.watch(homeProvider);
    final selectState = ref.watch(selectProvider);
    final colors = widget.colors;
    return SizedBox(
      height: 480.r,
      width: MediaQuery.sizeOf(context).width / 1.4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppHelpers.getTranslation(TrKeys.shop),
                  style: AppStyle.interNoSemi(
                    size: 16,
                    color: widget.colors.textBlack,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: widget.colors.textBlack),
              ),
            ],
          ),
          Expanded(
            child: SmartRefresher(
              controller: _recommendedController,
              enablePullDown: true,
              enablePullUp: true,
              onLoading: () async {
                await event.fetchShopPage(context, _recommendedController);
              },
              onRefresh: () async {
                await event.fetchShopPage(
                  context,
                  _recommendedController,
                  isRefresh: true,
                );
              },
              child: ListView.builder(
                itemCount: state.shops.length,
                shrinkWrap: true,
                padding: REdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: REdgeInsets.only(bottom: 8),
                    child: AnimationButtonEffect(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(selectProvider.notifier).selectIndex(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectState.selectedIndex == index
                                ? colors.primary.withValues(alpha: 0.4)
                                : widget.colors.icon,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: selectState.selectedIndex == index
                                  ? colors.primary
                                  : AppStyle.transparent,
                              width: 1.8,
                            ),
                          ),
                          child: Padding(
                            padding: REdgeInsets.all(8),
                            child: Row(
                              children: [
                                CustomNetworkImage(
                                  url: state.shops[index].logoImg,
                                  height: 48,
                                  width: 48,
                                  radius: 24,
                                ),
                                8.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    state.shops[index].translation?.title ??
                                        ' ',
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          CustomButton(
            title: AppHelpers.getTranslation(TrKeys.next),
            onPressed: () async {
              // ignore: deprecated_member_use
              await launch(
                "${AppConstants.webUrl}/reservations/${state.shops[selectState.selectedIndex].id}?guests=2&date_from=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
                enableJavaScript: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
