import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/profile/profile_notifier.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/profile/profile_state.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import '../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class WalletHistoryPage extends ConsumerStatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  ConsumerState<WalletHistoryPage> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends ConsumerState<WalletHistoryPage> {
  late RefreshController controller;
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    super.initState();
    controller = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getWallet(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final event = ref.read(profileProvider.notifier);

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: CustomScaffold(
        body: (colors) => Column(
          children: [
            CommonAppBar(
              child: Text(
                AppHelpers.getTranslation(TrKeys.transactions),
                style: AppStyle.interNoSemi(size: 18, color: colors.textBlack),
              ),
            ),
            _buildContent(state, event, colors),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: (colors) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const PopButton(),
        ),
      ),
    );
  }

  Widget _buildContent(
    ProfileState state,
    ProfileNotifier event,
    CustomColorSet colors,
  ) {
    if (state.isLoadingHistory) {
      return Padding(
        padding: EdgeInsets.only(top: 56.h),
        child: const Loading(),
      );
    }

    if (state.walletHistory?.isEmpty ?? true) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 64.r,
                color: AppStyle.textGrey,
              ),
              16.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.nothingFound),
                style: AppStyle.interRegular(
                  size: 16,
                  color: AppStyle.textGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        physics: const BouncingScrollPhysics(),
        controller: controller,
        onLoading: () => event.getWalletPage(context, controller),
        onRefresh: () =>
            event.getWallet(context, refreshController: controller),
        child: ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: state.walletHistory?.length ?? 0,
          itemBuilder: (context, index) {
            final history = state.walletHistory![index];
            return WalletHistoryItem(history: history, colors: colors);
          },
        ),
      ),
    );
  }
}

class WalletHistoryItem extends StatelessWidget {
  final WalletData history;
  final CustomColorSet colors;

  const WalletHistoryItem({
    super.key,
    required this.history,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(history.createdAt ?? "");

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: colors.icon,
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(createdAt),
          _buildDivider(),
          _buildDetails(createdAt),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime? createdAt) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (createdAt != null)
            Text(
              TimeService.dateFormatMDYHm(createdAt),
              style: AppStyle.interRegular(size: 12, color: AppStyle.textGrey),
            ),
          if (createdAt != null) 6.verticalSpace,
          Text(
            history.note ?? "",
            style: AppStyle.interSemi(size: 16, color: colors.textBlack),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppStyle.textGrey.withValues(alpha: 0.2),
      indent: 16.r,
      endIndent: 16.r,
    );
  }

  Widget _buildDetails(DateTime? createdAt) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _buildDetailRow(
            label: AppHelpers.getTranslation(TrKeys.paymentDate),
            value: createdAt != null
                ? TimeService.dateFormatDMY(createdAt)
                : "-",
          ),
          12.verticalSpace,
          if (history.author?.firstname != null)
            _buildDetailRow(
              label: AppHelpers.getTranslation(TrKeys.sender),
              value: history.author?.firstname ?? "",
            ),
          if (history.author?.firstname != null) 12.verticalSpace,
          _buildDetailRow(
            label: AppHelpers.getTranslation(TrKeys.deposit),
            value: AppHelpers.numberFormat(history.price),
            valueStyle: AppStyle.interSemi(
              size: 16,
              color: (history.price ?? 0) >= 0
                  ? colors.primary
                  : AppStyle.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyle.interRegular(size: 13, color: AppStyle.textGrey),
          ),
        ),
        8.horizontalSpace,
        Flexible(
          flex: 2,
          child: Text(
            value,
            style:
                valueStyle ??
                AppStyle.interRegular(size: 15, color: colors.textBlack),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
