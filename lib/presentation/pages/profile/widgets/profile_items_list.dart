import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/application/orders_list/orders_list_provider.dart';
import 'package:foodyman/application/parcels_list/parcel_list_provider.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/pages/profile/about_page.dart';
import 'package:foodyman/presentation/pages/profile/blog_page.dart';
import 'package:foodyman/presentation/pages/profile/careers/careers_page.dart';
import 'package:foodyman/presentation/pages/profile/currency_page.dart';
import 'package:foodyman/presentation/pages/profile/edit_profile_page.dart';
import 'package:foodyman/presentation/pages/profile/language_page.dart';
import 'package:foodyman/presentation/pages/profile/reservation_shops.dart';
import 'package:foodyman/presentation/pages/profile/widgets/profile_item_two.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_theme.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'profile_item.dart';

class ProfileItemsList extends ConsumerWidget {
  final bool isBackButton;
  final ProfileData? userData;
  final int? notificationCount;
  final VoidCallback onLanguageChange;
  final VoidCallback onDeleteAccount;
  final AppTheme theme;
  final CustomColorSet colors;

  const ProfileItemsList({
    super.key,
    required this.isBackButton,
    required this.userData,
    required this.notificationCount,
    required this.onLanguageChange,
    required this.onDeleteAccount,
    required this.theme,
    required this.colors,
  });

  bool get _isAuth => LocalStorage.getToken().isNotEmpty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ProfileItemTwo(
          colors: colors,
          title: AppHelpers.getTranslation(TrKeys.darkMode),
          icon: theme.isDark ? Icons.light_mode : Icons.dark_mode_outlined,
          onTap: () {},
          prefixWidget: SizedBox(
            height: 20,
            child: Switch(
              activeThumbColor: colors.primary,
              value: theme.isDark,
              onChanged: (value) {
                theme.toggle();
              },
            ),
          ),
        ),
        if (AppConstants.isDemo)
          ProfileItem(
            colors: colors,
            title: TrKeys.uiType,
            icon: FlutterRemix.typhoon_line,
            onTap: () => context.pushRoute(UiTypeRoute(isBack: true)),
          ),

        if (_isAuth) ...[
          ProfileItem(
            colors: colors,
            title: TrKeys.profileSettings,
            icon: FlutterRemix.user_settings_line,
            onTap: () {
              AppHelpers.showCustomModalBottomDragSheet(
                context: context,
                modal: (c) => EditProfileScreen(controller: c),
                isDarkMode: theme.isDark,
              );
            },
          ),

          ProfileItem(
            colors: colors,
            title:
                "${AppHelpers.getTranslation(TrKeys.wallet)}: ${AppHelpers.numberFormat(userData?.wallet?.price)}",
            icon: FlutterRemix.wallet_3_line,
            onTap: () => context.pushRoute(const WalletHistoryRoute()),
          ),

          if (AppHelpers.getReferralActive())
            ProfileItem(
              colors: colors,
              title: TrKeys.inviteFriend,
              icon: FlutterRemix.money_dollar_circle_line,
              onTap: () => context.pushRoute(const ShareReferralRoute()),
            ),
          ProfileItem(
            colors: colors,
            title: TrKeys.order,
            icon: FlutterRemix.history_line,
            isCount: true,
            count: ref.watch(ordersListProvider).totalActiveCount.toString(),
            onTap: () => context.pushRoute(const OrdersListRoute()),
          ),

          if (AppHelpers.getParcel())
            ProfileItem(
              colors: colors,
              title: TrKeys.parcels,
              icon: FlutterRemix.archive_line,
              isCount: true,
              count: ref.watch(parcelListProvider).totalActiveCount.toString(),
              onTap: () => context.pushRoute(const ParcelListRoute()),
            ),

          ProfileItem(
            colors: colors,
            title: TrKeys.notifications,
            icon: FlutterRemix.notification_2_line,
            isCount: true,
            count: (notificationCount ?? 0).toString(),
            onTap: () => context.pushRoute(const NotificationListRoute()),
          ),

          if (AppHelpers.getReservationEnable())
            ProfileItem(
              colors: colors,
              title: TrKeys.reservation,
              icon: FlutterRemix.reserved_line,
              onTap: () => AppHelpers.showAlertDialog(
                context: context,
                backgroundColor: theme.colors.backgroundColor,
                child: SizedBox(child: ReservationShops(colors: theme.colors)),
              ),
            ),

          ProfileItem(
            colors: colors,
            title: TrKeys.deliveryAddress,
            icon: FlutterRemix.user_location_line,
            onTap: () => context.pushRoute(const AddressListRoute()),
          ),
        ],

        if (isBackButton)
          ProfileItem(
            colors: colors,
            title: TrKeys.liked,
            icon: FlutterRemix.heart_3_line,
            onTap: () => context.pushRoute(LikeRoute()),
          ),

        if (_isAuth)
          ProfileItem(
            colors: colors,
            title: TrKeys.becomeSeller,
            icon: FlutterRemix.user_star_line,
            onTap: () => context.pushRoute(const CreateShopRoute()),
          ),

        if (_isAuth)
          ProfileItem(
            colors: colors,
            title: TrKeys.chatWithAdmin,
            icon: FlutterRemix.chat_1_line,
            onTap: () =>
                context.pushRoute(ChatRoute(roleId: "admin", name: "Admin")),
          ),

        ProfileItem(
          colors: colors,
          title: TrKeys.language,
          icon: FlutterRemix.global_line,
          onTap: () => AppHelpers.showCustomModalBottomSheet(
            isDismissible: true,
            context: context,
            modal: LanguageScreen(
              onSave: () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
                onLanguageChange();
              },
              colors: theme.colors,
            ),
            isDarkMode: theme.isDark,
          ),
        ),

        ProfileItem(
          colors: colors,
          title: TrKeys.currencies,
          icon: FlutterRemix.bank_card_line,
          onTap: () => AppHelpers.showCustomModalBottomSheet(
            context: context,
            modal: CurrencyScreen(colors: theme.colors),
            isDarkMode: theme.isDark,
          ),
        ),

        if (_isAuth)
          ProfileItem(
            colors: colors,
            title: TrKeys.setting,
            icon: FlutterRemix.settings_4_line,
            onTap: () => context.pushRoute(const SettingRoute()),
          ),

        ProfileItem(
          colors: colors,
          title: TrKeys.help,
          icon: FlutterRemix.question_line,
          onTap: () => context.pushRoute(const HelpRoute()),
        ),

        ProfileItem(
          colors: colors,
          title: TrKeys.about,
          icon: FlutterRemix.bill_line,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AboutPage()),
          ),
        ),

        ProfileItem(
          colors: colors,
          title: TrKeys.careers,
          icon: FlutterRemix.empathize_line,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CareerPage()),
          ),
        ),

        ProfileItem(
          colors: colors,
          title: TrKeys.blogs,
          icon: FlutterRemix.article_line,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BlogPage()),
          ),
        ),

        ProfileItem(
          colors: colors,
          title: TrKeys.privacyPolicy,
          icon: FlutterRemix.information_line,
          onTap: () => context.pushRoute(const PolicyRoute()),
        ),

        ProfileItem(
          colors: colors,
          title: TrKeys.terms,
          icon: FlutterRemix.file_info_line,
          onTap: () => context.pushRoute(const TermRoute()),
        ),

        if (_isAuth)
          ProfileItem(
            colors: colors,
            title: TrKeys.deleteAccount,
            icon: FlutterRemix.logout_box_r_line,
            onTap: onDeleteAccount,
          ),
      ],
    );
  }
}
