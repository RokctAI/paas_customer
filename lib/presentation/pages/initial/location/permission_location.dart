import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../../application/home/home_provider.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import '../../../theme/color_set.dart';
import '../../../theme/theme_wrapper.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class PermissionLocationPage extends ConsumerStatefulWidget {
  const PermissionLocationPage({super.key});

  @override
  ConsumerState<PermissionLocationPage> createState() =>
      _PermissionLocationPageState();
}

class _PermissionLocationPageState
    extends ConsumerState<PermissionLocationPage> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  CameraPosition? cameraPosition;
  LocationPermission? currentPermission;
  late LatLng latLng;
  String placeName = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCurrentPermission();
    });
  }

  Future<void> _checkCurrentPermission() async {
    final permission = await _geolocatorPlatform.checkPermission();
    setState(() {
      currentPermission = permission;
    });
  }

  Future<void> _handleAllowPermission() async {
    setState(() => isLoading = true);

    try {
      LocationPermission permission =
          currentPermission ?? LocationPermission.denied;

      if (permission == LocationPermission.denied) {
        permission = await _geolocatorPlatform.requestPermission();
        // Update currentPermission after requesting
        setState(() {
          currentPermission = permission;
        });

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          await getMyLocation();
          if (mounted) {
            context.replaceRoute(MainRoute());
          }
        } else if (permission == LocationPermission.deniedForever) {
          _showSettingsDialog();
        }
      } else if (permission == LocationPermission.deniedForever) {
        _showSettingsDialog();
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await getMyLocation();
        if (mounted) {
          context.replaceRoute(MainRoute());
        }
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppStyle.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_off_rounded,
                    size: 48.r,
                    color: AppStyle.red,
                  ),
                ),
                20.verticalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.locationPermissionDenied),
                  style: AppStyle.interSemi(size: 20, color: AppStyle.black),
                  textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                Text(
                  AppHelpers.getTranslation(
                    TrKeys.locationPermissionDeniedDescription,
                  ),
                  style: AppStyle.interNormal(
                    size: 14,
                    color: AppStyle.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.cancel),
                        background: AppStyle.bgGrey,
                        textColor: AppStyle.black,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.setting),
                        background: AppStyle.primary,
                        textColor: AppStyle.white,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Geolocator.openLocationSettings();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return CustomScaffold(
          body: (colors) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    (MediaQuery.paddingOf(context).top * 0.75).verticalSpace,
                    24.verticalSpace,
                    Text(
                      AppHelpers.getTranslation(TrKeys.enableLocationServices),
                      style: AppStyle.interSemi(
                        size: 20,
                        color: colors.textBlack,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    24.verticalSpace,

                    Container(
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(
                          alpha: 0.05,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(24.r),
                      child: Lottie.asset(
                        "assets/lottie/location.json",
                        height: 180.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    20.verticalSpace,

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        AppHelpers.getTranslation(
                          TrKeys.locationServicesDescription,
                        ),
                        textAlign: TextAlign.center,
                        style: AppStyle.interNormal(
                          size: 15,
                          color: AppStyle.textGrey,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    20.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: colors.newBoxColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          _buildBenefitItem(
                            colors: colors,
                            icon: Icons.location_on_rounded,
                            text: AppHelpers.getTranslation(
                              TrKeys.accurateDelivery,
                            ),
                          ),
                          10.verticalSpace,
                          _buildBenefitItem(
                            colors: colors,
                            icon: Icons.restaurant_rounded,
                            text: AppHelpers.getTranslation(
                              TrKeys.nearbyRestaurants,
                            ),
                          ),
                          10.verticalSpace,
                          _buildBenefitItem(
                            colors: colors,
                            icon: Icons.delivery_dining_rounded,
                            text: AppHelpers.getTranslation(
                              TrKeys.fasterService,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    if (currentPermission != null &&
                        (currentPermission ==
                            LocationPermission.deniedForever)) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 12.r,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyle.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_rounded,
                              size: 20.r,
                              color: AppStyle.red,
                            ),
                            8.horizontalSpace,
                            Text(
                              AppHelpers.getTranslation(
                                TrKeys.locationDeniedPermanently,
                              ),
                              style: AppStyle.interSemi(
                                size: 14,
                                color: AppStyle.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,
                    ],
                    // Allow button - Primary CTA
                    CustomButton(
                      title: AppHelpers.getTranslation(
                        isLoading ? TrKeys.pleaseWait : TrKeys.allow,
                      ),
                      background: colors.primary,
                      textColor: AppStyle.white,
                      onPressed: isLoading ? null : _handleAllowPermission,
                    ),
                    12.verticalSpace,
                    CustomButton(
                      title: AppHelpers.getTranslation(TrKeys.maybeLater),
                      background: colors.transparent,
                      textColor: colors.textHint,
                      borderColor: colors.textHint,
                      onPressed: isLoading
                          ? null
                          : () async {
                              final result = await context.pushRoute(
                                ViewMapRoute(isSelectLocation: true),
                              );
                              if (result != null && context.mounted) {
                                ref.read(homeProvider.notifier).setAddress();
                                context.replaceRoute(MainRoute());
                              }
                            },
                    ),

                    24.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String text,
    required CustomColorSet colors,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 18.r, color: colors.primary),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: AppStyle.interNormal(size: 13, color: colors.textBlack),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> getMyLocation() async {
    try {
      debugPrint("Getting location... currentPermission: $currentPermission");

      var loc = await Geolocator.getCurrentPosition();
      latLng = LatLng(loc.latitude, loc.longitude);

      debugPrint("Location received: $latLng");

      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          latLng.latitude,
          latLng.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark pos = placemarks[0];
          placeName = AppHelpers.formatAddress(pos);
          debugPrint("Address formatted: $placeName");
        }
      } catch (e) {
        debugPrint("Error formatting address: $e");
        placeName = "Location ${latLng.latitude}, ${latLng.longitude}";
      }

      debugPrint(
        "Address selected: $placeName, LatLng: $latLng, Permission: $currentPermission",
      );

      await LocalStorage.setAddressSelected(
        AddressData(
          title: placeName,
          location: LocationModel(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
          ),
        ),
      );

      debugPrint("Address saved to LocalStorage");
    } catch (e) {
      debugPrint("Error in getMyLocation: $e");
    }
  }
}
