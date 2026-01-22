// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/data/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/application/app/app_provider.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/address_information.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/address_old_data.dart'
    as address_selected;
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/pages/view_map/view_map_modal.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/map/view_map_notifier.dart';
import 'package:foodyman/application/map/view_map_provider.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class ViewMapPage extends ConsumerStatefulWidget {
  final bool isShopLocation;
  final bool isPop;
  final bool isParcel;
  final bool isSelectLocation;
  final int? shopId;
  final int? indexAddress;
  final AddressNewModel? address;

  const ViewMapPage({
    super.key,
    this.isParcel = false,
    this.isPop = true,
    this.isShopLocation = false,
    this.isSelectLocation = false,
    this.shopId,
    this.indexAddress,
    this.address,
  });

  @override
  ConsumerState<ViewMapPage> createState() => _ViewMapPageState();
}

class _ViewMapPageState extends ConsumerState<ViewMapPage> {
  late ViewMapNotifier event;
  late TextEditingController controller;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  GoogleMapController? googleMapController;
  CameraPosition? cameraPosition;
  dynamic check;
  late LatLng latLng;
  final Delayed delayed = Delayed(milliseconds: 700);

  // Cache for address to avoid repeated geocoding
  String? _lastGeocodedAddress;
  LatLng? _lastGeocodedLatLng;

  /// Gets address from coordinates with caching
  /// Returns formatted address string
  Future<String> _getAddressFromCoordinates(LatLng coordinates) async {
    if (_lastGeocodedLatLng != null &&
        _isSameLocation(_lastGeocodedLatLng!, coordinates)) {
      return _lastGeocodedAddress ?? '';
    }

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        final formattedAddress = AppHelpers.formatAddress(pos);

        _lastGeocodedLatLng = coordinates;
        _lastGeocodedAddress = formattedAddress;

        // Log detailed address info for debugging
        debugPrint('Geocoded address: $formattedAddress');
        debugPrint('House number: ${AppHelpers.extractHouseNumber(pos)}');
        debugPrint('Street: ${pos.thoroughfare ?? pos.street ?? "N/A"}');
        debugPrint('District: ${pos.subLocality ?? "N/A"}');
        debugPrint('City: ${pos.locality ?? "N/A"}');

        return formattedAddress;
      }
    } catch (e) {
      debugPrint('Error geocoding: $e');
    }

    return '';
  }

  /// Checks if two locations are close enough (within ~10 meters)
  bool _isSameLocation(LatLng a, LatLng b) {
    const double threshold = 0.0001; // approximately 10 meters
    return (a.latitude - b.latitude).abs() < threshold &&
        (a.longitude - b.longitude).abs() < threshold;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(viewMapProvider.notifier);
    super.didChangeDependencies();
  }

  Future<void> checkPermission() async {
    check = await _geolocatorPlatform.checkPermission();
  }

  Future<void> getMyLocation() async {
    if (check == LocationPermission.denied ||
        check == LocationPermission.deniedForever) {
      check = await Geolocator.requestPermission();
      if (check != LocationPermission.denied &&
          check != LocationPermission.deniedForever) {
        var loc = await Geolocator.getCurrentPosition();
        latLng = LatLng(loc.latitude, loc.longitude);
        googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15),
        );
      }
    } else {
      if (check != LocationPermission.deniedForever) {
        var loc = await Geolocator.getCurrentPosition();
        latLng = LatLng(loc.latitude, loc.longitude);
        googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15),
        );
      }
    }
  }

  @override
  void initState() {
    controller = TextEditingController();
    final addressLocation = widget.address?.location;
    final localLocation = LocalStorage.getAddressSelected()?.location;

    latLng = LatLng(
      (addressLocation != null && addressLocation.isNotEmpty)
          ? addressLocation[0]
          : localLocation?.latitude ??
                AppHelpers.getInitialLatitude() ??
                AppConstants.demoLatitude,

      (addressLocation != null && addressLocation.isNotEmpty)
          ? addressLocation[1]
          : localLocation?.longitude ??
                AppHelpers.getInitialLongitude() ??
                AppConstants.demoLongitude,
    );
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewMapProvider);
    final bool isLtr = LocalStorage.getLangLtr();
    final bool isDarkMode = ref.watch(appProvider).isDarkMode;
    return KeyboardDismisser(
      child: Directionality(
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        child: CustomScaffold(
          body: (colors) => SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: state.isScrolling
                      ? MediaQuery.sizeOf(context).height
                      : MediaQuery.sizeOf(context).height - 0.r,
                  child: GoogleMap(
                    style: LocalStorage.getAppThemeMode()
                        ? jsonEncode(AppMapThemes.mapDarkTheme)
                        : null,
                    onCameraMoveStarted: () {
                      ref.read(viewMapProvider.notifier).scrolling(true);
                    },
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      bearing: 0,
                      target: latLng,
                      tilt: 0,
                      zoom: 17,
                    ),
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    onTap: (position) {
                      event.updateActive();
                      delayed.run(() async {
                        final currentLocation = LatLng(
                          cameraPosition?.target.latitude ?? latLng.latitude,
                          cameraPosition?.target.longitude ?? latLng.longitude,
                        );

                        // Get address with caching
                        controller.text = await _getAddressFromCoordinates(
                          currentLocation,
                        );

                        event
                          ..checkDriverZone(
                            context: context,
                            location: currentLocation,
                            shopId: widget.shopId,
                          )
                          ..changePlace(
                            AddressNewModel(
                              address: AddressInformation(
                                address: controller.text,
                              ),
                              location: [
                                currentLocation.latitude,
                                currentLocation.longitude,
                              ],
                            ),
                          );
                      });
                      googleMapController!.animateCamera(
                        CameraUpdate.newLatLngZoom(position, 15),
                      );
                    },
                    onCameraIdle: () {
                      event.updateActive();
                      delayed.run(() async {
                        final currentLocation = LatLng(
                          cameraPosition?.target.latitude ?? latLng.latitude,
                          cameraPosition?.target.longitude ?? latLng.longitude,
                        );

                        // Get address with caching
                        controller.text = await _getAddressFromCoordinates(
                          currentLocation,
                        );

                        // Update place model
                        final addressModel = AddressNewModel(
                          address: AddressInformation(address: controller.text),
                          location: [
                            currentLocation.latitude,
                            currentLocation.longitude,
                          ],
                        );

                        if (!widget.isShopLocation) {
                          event
                            ..checkDriverZone(
                              context: context,
                              location: currentLocation,
                              shopId: widget.shopId,
                            )
                            ..changePlace(addressModel);
                        } else {
                          event.changePlace(addressModel);
                        }

                        ref.read(viewMapProvider.notifier).scrolling(false);
                      });
                    },
                    onCameraMove: (position) {
                      cameraPosition = position;
                    },
                    onMapCreated: (controller) {
                      googleMapController = controller;
                    },
                  ),
                ),
                AnimatedPositioned(
                  bottom:
                      MediaQuery.paddingOf(context).bottom +
                      (MediaQuery.sizeOf(context).height / 2),
                  left: MediaQuery.sizeOf(context).width / 2 - 23.w,
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    "assets/images/marker.png",
                    width: 46.w,
                    height: 46.h,
                  ),
                ),
                AnimatedPositioned(
                  top: MediaQuery.paddingOf(context).top + 12,
                  left: 24,
                  right: 24,
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.textWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: SearchTextField(
                        isRead: true,
                        hintText: AppHelpers.getTranslation(TrKeys.search),
                        textEditingController: TextEditingController(
                          text: controller.text,
                        ),
                        onTap: () async {
                          final LatLng? result = await context.pushRoute(
                            const MapSearchRoute(),
                          );

                          if (result != null) {
                            await _applySelectedLocation(result);
                          }
                        },
                      ),
                    ),
                    // Text(
                    //   controller.text,
                    //   style: AppStyle.interNormal(size: 16),
                    //   textAlign: TextAlign.center,
                    // ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  bottom: 94.r,
                  right: state.isScrolling ? -100 : 16.w,
                  child: InkWell(
                    onTap: () async {
                      await getMyLocation();
                    },
                    child: Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                        color: colors.textWhite,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: colors.textWhite,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          FlutterRemix.navigation_line,
                          color: colors.textBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.address != null &&
                    !(widget.address?.active ?? false))
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: 32.r,
                    right: state.isScrolling ? -100 : 16.w,
                    child: InkWell(
                      onTap: () async {
                        ref
                            .read(profileProvider.notifier)
                            .deleteAddress(
                              index: widget.indexAddress ?? 0,
                              id: widget.address?.id,
                            );
                        context.maybePop();
                      },
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: AppStyle.red,
                          borderRadius: BorderRadius.all(Radius.circular(24.r)),
                          boxShadow: [
                            BoxShadow(
                              color: AppStyle.shimmerBase,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            FlutterRemix.delete_bin_fill,
                            color: AppStyle.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  left: 16,
                  right: 16,
                  bottom: 32,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      if (widget.isPop)
                        Padding(
                          padding: REdgeInsets.only(right: 8),
                          child: const PopButton(),
                        ),
                      Expanded(
                        child: Opacity(
                          opacity: state.isScrolling ? 0.5 : 1,
                          child: CustomButton(
                            isLoading: controller.text.isEmpty,
                            title: AppHelpers.getTranslation(TrKeys.apply),
                            onPressed: () async {
                              // Handle isSelectLocation - save to local storage and return
                              if (widget.isSelectLocation) {
                                await LocalStorage.setAddressSelected(
                                  address_selected.AddressData(
                                    title: controller.text,
                                    address: controller.text,
                                    location: LocationModel(
                                      longitude:
                                          cameraPosition?.target.longitude ??
                                          latLng.longitude,
                                      latitude:
                                          cameraPosition?.target.latitude ??
                                          latLng.latitude,
                                    ),
                                  ),
                                );
                                if (context.mounted) {
                                  Navigator.pop(context, true);
                                }
                                return;
                              }

                              if (widget.isParcel) {
                                Navigator.pop(
                                  context,
                                  AddressNewModel(
                                    address: AddressInformation(
                                      address: controller.text,
                                    ),
                                    location: [
                                      cameraPosition?.target.latitude ??
                                          latLng.latitude,
                                      cameraPosition?.target.longitude ??
                                          latLng.longitude,
                                    ],
                                  ),
                                );
                                return;
                              }
                              if (!state.isScrolling) {
                                AppHelpers.showCustomModalBottomSheet(
                                  paddingTop: -50,
                                  context: context,
                                  modal: ViewMapModal(
                                    colors: colors,
                                    controller: controller,
                                    address: widget.address,
                                    latLng: latLng,
                                    isShopLocation: widget.isShopLocation,
                                    onSearch: () async {
                                      final placeId = await context.pushRoute(
                                        const MapSearchRoute(),
                                      );
                                      if (placeId != null) {
                                        final res = await googlePlace.details
                                            .get(placeId.toString());

                                        final searchLocation = LatLng(
                                          res
                                                  ?.result
                                                  ?.geometry
                                                  ?.location
                                                  ?.lat ??
                                              latLng.latitude,
                                          res
                                                  ?.result
                                                  ?.geometry
                                                  ?.location
                                                  ?.lng ??
                                              latLng.longitude,
                                        );

                                        // Get address with caching
                                        controller.text =
                                            await _getAddressFromCoordinates(
                                              searchLocation,
                                            );

                                        googleMapController!.animateCamera(
                                          CameraUpdate.newLatLngZoom(
                                            searchLocation,
                                            15,
                                          ),
                                        );

                                        event.changePlace(
                                          AddressNewModel(
                                            address: AddressInformation(
                                              address: controller.text,
                                            ),
                                            location: [
                                              searchLocation.latitude,
                                              searchLocation.longitude,
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  isDarkMode: isDarkMode,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _applySelectedLocation(LatLng result) async {
    latLng = result;

    googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(result, 15));

    // Get address with caching
    controller.text = await _getAddressFromCoordinates(result);

    event.changePlace(
      AddressNewModel(
        address: AddressInformation(address: controller.text),
        location: [result.latitude, result.longitude],
      ),
    );
  }
}
