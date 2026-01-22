import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/notification/notification_provider.dart';
import 'package:foodyman/application/orders_list/orders_list_provider.dart';
import 'package:foodyman/application/parcels_list/parcel_list_provider.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/application/like/like_provider.dart';
import 'package:foodyman/presentation/pages/profile/delete_screen.dart';
import 'package:foodyman/presentation/pages/profile/widgets/profile_header.dart';
import 'package:foodyman/presentation/pages/profile/widgets/profile_items_list.dart';
import '../../theme/theme_wrapper.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  final bool isBackButton;

  const ProfilePage({super.key, this.isBackButton = true});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late RefreshController _refreshController;
  late Timer _timer;

  bool get _isAuthenticated => LocalStorage.getToken().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _initializeAuthenticatedUser();
  }

  void _initializeAuthenticatedUser() {
    if (_isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchUserData();
        _startNotificationTimer();
      });
    }
  }

  void _fetchUserData() {
    ref.read(profileProvider.notifier).fetchUser(context);
    ref.read(ordersListProvider.notifier).fetchActiveOrders(context);
    ref.read(parcelListProvider.notifier).fetchActiveOrders(context);
  }

  void _startNotificationTimer() {
    _timer = Timer.periodic(AppConstants.timeRefresh, (_) {
      ref.read(notificationProvider.notifier).fetchCount(context);
    });
  }

  void _refreshAllInformation() {
    if (!_isAuthenticated) return;

    final homeNotifier = ref.read(homeProvider.notifier);
    homeNotifier
      ..setAddress()
      ..fetchBanner(context)
      ..fetchRestaurant(context)
      ..fetchShopRecommend(context)
      ..fetchShop(context)
      ..fetchStore(context)
      ..fetchRestaurantNew(context)
      ..fetchCategories(context);

    ref.read(shopOrderProvider.notifier).getCart(context, () {});
    ref.read(likeProvider.notifier).fetchLikeShop(context);
    ref.read(profileProvider.notifier).fetchUser(context);
  }

  void _handleRefresh() {
    ref
        .read(profileProvider.notifier)
        .fetchUser(context, refreshController: _refreshController);
    ref.read(ordersListProvider.notifier).fetchActiveOrders(context);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    if (_isAuthenticated) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final notificationState = ref.watch(notificationProvider);
    return CustomScaffold(
      body: (colors) => profileState.isLoading
          ? const Loading()
          : Column(
              children: [
                ProfileHeader(
                  userData: profileState.userData,
                  onLogout: () {
                    AppHelpers.showAlertDialog(
                      context: context,
                      backgroundColor: colors.backgroundColor,
                      child: DeleteScreen(
                        onDelete: () => _timer.cancel(),
                        colors: colors,
                      ),
                    );
                  },
                  colors: colors,
                ),
                Expanded(
                  child: SmartRefresher(
                    onRefresh: _handleRefresh,
                    enablePullDown: LocalStorage.getToken().isNotEmpty,
                    enablePullUp: false,
                    controller: _refreshController,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: 24.r,
                        right: 16.r,
                        left: 16.r,
                        bottom: 120.r,
                      ),
                      child: ThemeWrapper(
                        builder: (co, controller) {
                          return ProfileItemsList(
                            isBackButton: widget.isBackButton,
                            theme: controller,
                            userData: profileState.userData,
                            notificationCount: notificationState
                                .countOfNotifications
                                ?.notification,
                            onLanguageChange: () {
                              controller.toggle();
                              controller.toggle();
                              _refreshAllInformation();
                            },
                            onDeleteAccount: () {
                              AppHelpers.showAlertDialog(
                                context: context,
                                backgroundColor: colors.backgroundColor,
                                child: DeleteScreen(
                                  isDeleteAccount: true,
                                  onDelete: () => _timer.cancel(),
                                  colors: colors,
                                ),
                              );
                            },
                            colors: colors,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (colors) => widget.isBackButton
          ? Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: const PopButton(),
            )
          : null,
    );
  }
}
