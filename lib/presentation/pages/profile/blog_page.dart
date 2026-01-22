import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/data/blog_data.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/pages/profile/select_blog_page.dart';

import '../../../application/profile/profile_provider.dart';
import '../../theme/app_style.dart';
import '../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class BlogPage extends ConsumerStatefulWidget {
  const BlogPage({super.key});

  @override
  ConsumerState<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends ConsumerState<BlogPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((d) {
      ref.read(profileProvider.notifier).getBlogs();
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
              AppHelpers.getTranslation(TrKeys.blogs),
              style: AppStyle.interNoSemi(size: 18, color: colors.textBlack),
            ),
          ),
          // 20.verticalSpace,
          state.isLoading
              ? Column(children: [200.verticalSpace, Loading()])
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 10.r,
                  ),
                  itemCount: state.blogs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _blogItem(state.blogs[index], colors);
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

  Widget _blogItem(BlogData blog, CustomColorSet colors) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectBlogPage(blogUuid: blog.uuid ?? "", colors: colors),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: colors.icon,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                url: blog.img,
                radius: 12,
                height: 200,
                width: double.infinity,
              ),
              10.verticalSpace,
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.translation?.title ?? "",
                      style: AppStyle.interBold(
                        size: 14,
                        color: colors.textBlack,
                      ),
                    ),
                    Text(
                      blog.translation?.shortDesc ?? "",
                      style: TextStyle(color: colors.textBlack),
                    ),
                    Divider(),
                    Text(
                      TimeService.dateFormatMDHm(
                        DateTime.parse(blog.createdAt ?? ""),
                      ),
                      style: TextStyle(color: colors.textBlack),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
