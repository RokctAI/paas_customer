import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/pages/profile/careers/career_data_page.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import '../../../../infrastructure/models/data/career_data.dart';
import '../../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class CareerPage extends ConsumerStatefulWidget {
  const CareerPage({super.key});

  @override
  ConsumerState<CareerPage> createState() => _CareerDataPageState();
}

class _CareerDataPageState extends ConsumerState<CareerPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) {
      ref.read(profileProvider.notifier).getCareers();
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
              AppHelpers.getTranslation(TrKeys.careers),
              style: AppStyle.interNoSemi(size: 18),
            ),
          ),
          20.verticalSpace,
          state.isLoading
              ? Column(children: [200.verticalSpace, Loading()])
              : ListView.builder(
                  itemCount: state.careers.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.r),
                  itemBuilder: (context, index) {
                    return _itemCareerData(state.careers[index], colors);
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

  Widget _itemCareerData(CareerData career, CustomColorSet colors) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CareerDataPage(id: career.id ?? 0),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.icon,
          // border: Border.all(color: AppStyle.textGrey.withAlpha(90)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                career.translation?.title ?? '',
                style: AppStyle.interSemi(size: 14, color: colors.textBlack),
              ),
              Text(
                AppHelpers.getTranslation(TrKeys.role),
                style: TextStyle(color: colors.textBlack),
              ),
              12.verticalSpace,
              Text(
                career.category?.translation?.title ?? '',
                style: AppStyle.interSemi(size: 14, color: colors.textBlack),
              ),
              Text(
                AppHelpers.getTranslation(TrKeys.categories),
                style: TextStyle(color: colors.textBlack),
              ),
              12.verticalSpace,

              Text(
                career.translation?.address ?? '',
                style: AppStyle.interSemi(size: 14, color: colors.textBlack),
              ),
              Text(
                AppHelpers.getTranslation(TrKeys.location),
                style: TextStyle(color: colors.textBlack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
