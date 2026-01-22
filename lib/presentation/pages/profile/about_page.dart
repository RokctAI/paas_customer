import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/response/pages_response.dart';
import '../../../application/profile/profile_provider.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../theme/app_style.dart';
import '../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) {
      ref.read(profileProvider.notifier).getAbout();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return CustomScaffold(
      body: (colors) => ListView(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(TrKeys.about),
              style: AppStyle.interNoSemi(size: 18, color: colors.textBlack),
            ),
          ),
          12.verticalSpace,
          state.isLoading
              ? Column(children: [200.verticalSpace, Loading()])
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.r),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.about.length,
                  itemBuilder: (context, index) {
                    return _aboutItem(state.about[index], colors);
                  },
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (colors) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const PopButton(),
      ),
    );
  }

  Widget _aboutItem(PageData data, CustomColorSet colors) {
    return Column(
      children: [
        CustomNetworkImage(url: data.img, radius: 12, height: 320, width: 250),
        20.verticalSpace,
        Text(
          data.translation?.title ?? "",
          style: AppStyle.interSemi(color: colors.textBlack),
        ),
        12.verticalSpace,
        Html(
          data: data.translation?.description ?? "",
          style: {
            "body": Style(color: colors.textBlack, fontSize: FontSize(14.sp)),
          },
        ),
      ],
    );
  }
}
