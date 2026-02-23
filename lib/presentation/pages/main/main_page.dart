import 'package:auto_route/auto_route.dart';
import 'package:foodyman/infrastructure/app_links/app_links_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/main/main_notifier.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/models/data/cart_data.dart';
import 'package:foodyman/infrastructure/models/data/profile_data.dart';
import 'package:foodyman/infrastructure/models/data/remote_message_data.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/pages/home/home_one/home_one_page.dart';
import 'package:foodyman/presentation/pages/home/home_page.dart';
import 'package:foodyman/presentation/pages/home/home_three/home_page_three.dart';
import 'package:foodyman/presentation/pages/like/like_page.dart';
import 'package:foodyman/presentation/pages/main/widgets/bottom_navigator_three.dart';
import 'package:foodyman/presentation/pages/profile/profile_page.dart';
import 'package:foodyman/presentation/pages/search/search_page.dart';
import 'package:foodyman/presentation/pages/service/service_page.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:foodyman/application/main/main_provider.dart';
import '../home/home_two/home_two_page.dart';
import 'widgets/bottom_navigator_item.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'widgets/bottom_navigator_one.dart';
import 'widgets/bottom_navigator_two.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  final bool isListen;

  const MainPage({super.key, this.isListen = true});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List listPages = [
    [
      IndexedStackChild(child: const HomePage(), preload: true),
      IndexedStackChild(child: const SearchPage(isBackButton: false)),
      IndexedStackChild(child: const LikePage(isBackButton: false)),
      IndexedStackChild(
        child: const ProfilePage(isBackButton: false),
        preload: true,
      ),
    ],
    [
      IndexedStackChild(child: const HomeOnePage(), preload: true),
      IndexedStackChild(child: const ServicePage()),
    ],
    [
      IndexedStackChild(child: const HomeTwoPage(), preload: true),
      IndexedStackChild(child: const ServicePage()),
    ],
    [
      IndexedStackChild(child: const HomePageThree(), preload: true),
      IndexedStackChild(child: const ServicePage()),
    ],
  ];

  @override
  void initState() {
    if (widget.isListen) AppLinksService.init(context, isMain: true);
    FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
      badge: false,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteMessageData data = RemoteMessageData.fromJson(message.data);
      if (data.type == "news_publish") {
        if (mounted) {
          context.router.popUntilRoot();
        }
        // ignore: deprecated_member_use
        await launch(
          "${AppConstants.webUrl}/blog/${message.data["uuid"]}",
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        if (mounted) {
          context.router.popUntilRoot();
          if (data.id != null) {
            context.pushRoute(OrderProgressRoute(orderId: data.id!));
          }
        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteMessageData data = RemoteMessageData.fromJson(message.data);
      if (data.type == "news_publish" && mounted) {
        AppHelpers.showCheckTopSnackBarInfoCustom(
          context,
          "${message.notification?.body}",
          onTap: () async {
            context.router.popUntilRoot();
            await launch(
              "${AppConstants.webUrl}/blog/${message.data["uuid"]}",
              forceSafariVC: true,
              forceWebView: true,
              enableJavaScript: true,
            );
          },
        );
      } else if (mounted) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          "${AppHelpers.getTranslation(TrKeys.id)} #${message.notification?.title} ${message.notification?.body}",
          onTap: () async {
            context.router.popUntilRoot();
            if (data.id != null) {
              context.pushRoute(OrderProgressRoute(orderId: data.id!));
            }
          },
        );
      }
    });
    super.initState();
  }

  // Deep linking is now handled by AppLinksService
  // This method is kept for compatibility but functionality moved to AppLinksService

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: CustomScaffold(
        // extendBody: true,
        body: (colors) => Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final index = ref.watch(mainProvider).selectIndex;
            return ProsteIndexedStack(
              index: index,
              children: listPages[AppHelpers.getType()],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (colors) => AppHelpers.getType() == 0
            ? Consumer(
                builder: (context, ref, child) {
                  final index = ref.watch(mainProvider).selectIndex;
                  final user = ref.watch(profileProvider).userData;
                  final orders = ref.watch(shopOrderProvider).cart;
                  final event = ref.read(mainProvider.notifier);
                  return _bottom(index, ref, event, context, user, orders);
                },
              )
            : AppHelpers.getType() == 3
            ? Consumer(
                builder: (context, ref, child) {
                  return BottomNavigatorThree(
                    currentIndex: ref.watch(mainProvider).selectIndex,
                    onTap: (int value) {
                      if (value == 3) {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const OrderRoute());
                        return;
                      }
                      if (value == 2) {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const ParcelRoute());
                        return;
                      }
                      ref.read(mainProvider.notifier).selectIndex(value);
                    },
                    colors: colors,
                  );
                },
              )
            : const SizedBox(),
        bottomNavigationBar: (colors) => Consumer(
          builder: (context, ref, child) {
            final index = ref.watch(mainProvider).selectIndex;
            final event = ref.read(mainProvider.notifier);
            return AppHelpers.getType() == 1
                ? BottomNavigatorOne(
                    colors: colors,
                    currentIndex: index,
                    onTap: (int value) {
                      if (value == 3) {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const OrderRoute());
                        return;
                      }
                      if (value == 2) {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const ParcelRoute());
                        return;
                      }
                      event.selectIndex(value);
                    },
                  )
                : AppHelpers.getType() == 2
                ? BottomNavigatorTwo(
                    colors: colors,
                    currentIndex: index,
                    onTap: (int value) {
                      if (value == 3) {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const OrderRoute());
                        return;
                      }
                      if (value == 2) {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const ParcelRoute());
                        return;
                      }
                      event.selectIndex(value);
                    },
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _bottom(
    int index,
    WidgetRef ref,
    MainNotifier event,
    BuildContext context,
    ProfileData? user,
    Cart? orders,
  ) {
    final mainState = ref.watch(mainProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlurWrap(
          radius: BorderRadius.circular(100.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: AppStyle.bottomNavigationBarColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(100.r),
            ),
            height: 60.r,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.r),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomNavigatorItem(
                    isScrolling: index == 3 ? false : mainState.isScrolling,
                    selectItem: () {
                      event.changeScrolling(false);
                      event.selectIndex(0);
                    },
                    index: 0,
                    currentIndex: index,
                    selectIcon: FlutterRemix.restaurant_fill,
                    unSelectIcon: FlutterRemix.restaurant_line,
                  ),
                  BottomNavigatorItem(
                    isScrolling: index == 3 ? false : mainState.isScrolling,
                    selectItem: () {
                      event.changeScrolling(false);
                      event.selectIndex(1);
                    },
                    currentIndex: index,
                    index: 1,
                    selectIcon: FlutterRemix.search_fill,
                    unSelectIcon: FlutterRemix.search_line,
                  ),
                  BottomNavigatorItem(
                    isScrolling: index == 3 ? false : mainState.isScrolling,
                    selectItem: () {
                      event.changeScrolling(false);
                      event.selectIndex(2);
                    },
                    currentIndex: index,
                    index: 2,
                    selectIcon: FlutterRemix.heart_fill,
                    unSelectIcon: FlutterRemix.heart_line,
                  ),
                  GestureDetector(
                    onTap: () {
                      event.changeScrolling(false);
                      event.selectIndex(3);
                    },
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == 3
                              ? AppStyle.primary
                              : AppStyle.transparent,
                          width: 2.w,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CustomNetworkImage(
                        profile: true,
                        url: user?.img ?? LocalStorage.getUser()?.img,
                        height: 40.r,
                        width: 40..r,
                        radius: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        orders == null ||
                (orders.userCarts?.isEmpty ?? true) ||
                ((orders.userCarts?.isEmpty ?? true)
                    ? true
                    : (orders.userCarts?.first.cartDetails?.isEmpty ?? true)) ||
                orders.ownerId != LocalStorage.getUser()?.id
            ? const SizedBox.shrink()
            : AnimationButtonEffect(
                child: GestureDetector(
                  onTap: () {
                    context.pushRoute(const OrderRoute());
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8.w),
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppStyle.primary,
                    ),
                    child: Icon(
                      FlutterRemix.shopping_bag_3_line,
                      color: AppStyle.buttonFontColor,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
