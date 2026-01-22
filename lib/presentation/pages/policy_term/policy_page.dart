import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class PolicyPage extends ConsumerStatefulWidget {
  const PolicyPage({super.key});

  @override
  ConsumerState<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends ConsumerState<PolicyPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getPolicy(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return CustomScaffold(
      body: (colors) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.privacy),
              style: AppStyle.interNoSemi(size: 18, color: colors.textBlack),
            ),
            state.isPolicyLoading
                ? const Center(child: Loading())
                : Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.policy?.title ?? "",
                            style: AppStyle.interNoSemi(
                              color: colors.textBlack,
                            ),
                          ),
                          8.verticalSpace,
                          Html(
                            data: state.policy?.description ?? "",
                            style: {"body": Style(color: colors.textBlack)},
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (colors) => const PopButton(),
    );
  }
}
