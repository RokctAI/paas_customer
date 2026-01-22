import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/app_constants.dart';
import 'package:share_plus/share_plus.dart';

import '../../../application/profile/profile_provider.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../theme/app_style.dart';
import '../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class SelectBlogPage extends ConsumerStatefulWidget {
  final String blogUuid;
  final CustomColorSet colors;
  const SelectBlogPage({
    super.key,
    required this.blogUuid,
    required this.colors,
  });

  @override
  ConsumerState<SelectBlogPage> createState() => _SelectBlogPageState();
}

class _SelectBlogPageState extends ConsumerState<SelectBlogPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((d) {
      ref.read(profileProvider.notifier).getSelectBlog(widget.blogUuid);
    });
    super.initState();
  }

  CustomColorSet get colors => widget.colors;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(
                state.selectBlog?.translation?.title ?? "",
              ),
              style: AppStyle.interNoSemi(size: 18, color: colors.textBlack),
            ),
          ),
          state.isLoading
              ? Column(children: [200.verticalSpace, Loading()])
              : ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 10.r,
                  ),
                  shrinkWrap: true,
                  children: [
                    Text(
                      state.selectBlog?.translation?.title ?? "",
                      style: AppStyle.interSemi(
                        size: 14,
                        color: colors.textBlack,
                      ),
                    ),
                    16.verticalSpace,
                    if (state.selectBlog?.img != null)
                      CustomNetworkImage(
                        url: state.selectBlog!.img!,
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        radius: 12,
                      ),
                    12.verticalSpace,
                    CustomButton(
                      title: "Share",
                      icon: Icon(FlutterRemix.share_line),
                      background: AppStyle.black,
                      textColor: AppStyle.white,
                      onPressed: () {
                        SharePlus.instance.share(
                          ShareParams(
                            text:
                                "${AppConstants.baseUrl}/blog/${state.selectBlog?.uuid}",
                          ),
                        );
                      },
                    ),
                    Html(
                      data: state.selectBlog?.translation?.description ?? "",
                      style: {"body": Style(color: colors.textBlack)},
                    ),
                  ],
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const PopButton(),
      ),
    );
  }
}
