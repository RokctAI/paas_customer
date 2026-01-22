import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodyman/application/profile/profile_provider.dart';

import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/components/components.dart';

class CareerDataPage extends ConsumerStatefulWidget {
  final int id;

  const CareerDataPage({super.key, required this.id});

  @override
  ConsumerState<CareerDataPage> createState() => _CareerDataPageState();
}

class _CareerDataPageState extends ConsumerState<CareerDataPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) {
      ref.read(profileProvider.notifier).getCareerData(widget.id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return CustomScaffold(
      body: (colors) => Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(
                state.selectedCareer?.translation?.title ?? "",
              ),
              style: AppStyle.interNoSemi(size: 18, color: colors.textBlack),
            ),
          ),
          20.verticalSpace,
          state.isLoading
              ? Column(children: [200.verticalSpace, Loading()])
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.r),
                  shrinkWrap: true,
                  children: [
                    Text(
                      state.selectedCareer?.translation?.address ?? "",
                      style: AppStyle.interNormal(
                        size: 14,
                        color: colors.textBlack,
                      ),
                    ),
                    12.verticalSpace,
                    Html(
                      data:
                          state.selectedCareer?.translation?.description ?? "",
                      style: {"body": Style(color: colors.textBlack)},
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.h),
                      padding: EdgeInsets.all(16.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppStyle.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppStyle.textGrey),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/contact.svg",
                                colorFilter: ColorFilter.mode(
                                  colors.textBlack,
                                  BlendMode.srcIn,
                                ),
                              ),
                              20.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppHelpers.getTranslation(
                                      TrKeys.stillHaveQuestions,
                                    ),
                                    style: AppStyle.interSemi(
                                      size: 14,
                                      color: colors.textBlack,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width / 1.5,
                                    child: Text(
                                      AppHelpers.getTranslation(
                                        TrKeys.cantFindTheAnswer,
                                      ),
                                      style: AppStyle.interRegular(
                                        size: 12,
                                        color: colors.textBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.helpCenter),
                            background: AppStyle.black,
                            textColor: AppStyle.white,
                            onPressed: () {
                              context.pushRoute(
                                ChatRoute(roleId: "admin", name: "Admin"),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
}
