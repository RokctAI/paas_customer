import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/currency/currency_provider.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'widgets/currency_item.dart';

import 'package:foodyman/presentation/components/components.dart';

class CurrencyScreen extends ConsumerStatefulWidget {
  final CustomColorSet colors;
  const CurrencyScreen({super.key, required this.colors});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<CurrencyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currencyProvider.notifier).fetchCurrency(context);
    });
  }

  @override
  void deactivate() {
    ref
        .read(profileProvider.notifier)
        .fetchUser(context, refreshController: RefreshController());
    ref.read(shopOrderProvider.notifier).getCart(context, () {});
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final event = ref.read(currencyProvider.notifier);
    final state = ref.watch(currencyProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          decoration: BoxDecoration(
            color: widget.colors.backgroundColor.withValues(alpha: 0.96),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: state.isLoading
                ? const Loading()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      Center(
                        child: Container(
                          height: 4.r,
                          width: 48.r,
                          decoration: BoxDecoration(
                            color: AppStyle.dragElement,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      TitleAndIcon(
                        title: AppHelpers.getTranslation(TrKeys.currencies),
                        paddingHorizontalSize: 0,
                        titleSize: 18,
                      ),
                      24.verticalSpace,
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          return CurrencyItem(
                            onTap: () => event.change(index),
                            isActive: state.index == index,
                            title:
                                "${state.list[index].title ?? ""} - ${state.list[index].symbol ?? ""}",
                            colors: widget.colors,
                          );
                        },
                      ),
                      24.verticalSpace,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
