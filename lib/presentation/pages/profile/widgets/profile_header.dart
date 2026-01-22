import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/data/profile_data.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileData? userData;
  final VoidCallback onLogout;
  final CustomColorSet colors;

  const ProfileHeader({
    super.key,
    required this.userData,
    required this.onLogout,
    required this.colors,
  });

  bool get _isAuthenticated => LocalStorage.getToken().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: !_isAuthenticated
                  ? () => context.pushRoute(const LoginRoute())
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAvatar(),
                  12.horizontalSpace,
                  Expanded(child: _buildUserInfo()),
                ],
              ),
            ),
          ),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      height: 40.r,
      width: 40.r,
      child: _isAuthenticated
          ? CustomNetworkImage(
              profile: true,
              url: userData?.img ?? "",
              height: 40.r,
              width: 40.r,
              radius: 30.r,
            )
          : Container(
              decoration: BoxDecoration(
                color: AppStyle.bgGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FlutterRemix.user_line,
                color: AppStyle.textGrey,
                size: 24.r,
              ),
            ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          _isAuthenticated
              ? "${userData?.firstname ?? ""} ${userData?.lastname ?? ""}"
              : AppHelpers.getTranslation(TrKeys.guest),
          style: AppStyle.interNormal(size: 14, color: colors.textBlack),
          maxLines: 1,
        ),
        Text(
          _isAuthenticated
              ? (userData?.email ?? " ")
              : AppHelpers.getTranslation(TrKeys.tapToSignIn),
          style: AppStyle.interRegular(size: 12, color: AppStyle.textGrey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (_isAuthenticated) {
          onLogout();
        } else {
          context.pushRoute(const LoginRoute());
        }
      },
      icon: Icon(
        _isAuthenticated
            ? FlutterRemix.logout_circle_r_line
            : FlutterRemix.login_circle_line,
        size: 21.r,
        color: colors.textBlack,
      ),
    );
  }
}
