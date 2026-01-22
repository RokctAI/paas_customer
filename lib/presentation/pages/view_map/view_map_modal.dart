import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/map/view_map_provider.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/presentation/components/components.dart';

class ViewMapModal extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final AddressNewModel? address;
  final LatLng latLng;
  final bool isShopLocation;
  final VoidCallback onSearch;
  final CustomColorSet colors;

  const ViewMapModal({
    super.key,
    required this.controller,
    required this.address,
    required this.latLng,
    required this.isShopLocation,
    required this.onSearch,
    required this.colors,
  });

  @override
  ConsumerState<ViewMapModal> createState() => _ViewMapModalState();
}

class _ViewMapModalState extends ConsumerState<ViewMapModal> {
  late TextEditingController office;
  late TextEditingController house;
  late TextEditingController floor;
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    office = TextEditingController(text: widget.address?.title);

    // Extract house number from address if available
    final extractedHouse = _extractHouseNumber(widget.controller.text);
    house = TextEditingController(text: extractedHouse);

    floor = TextEditingController();

    widget.controller.addListener(_onAddressChanged);

    super.initState();
  }

  void _onAddressChanged() {
    // Only auto-fill if house field is empty
    if (house.text.isEmpty) {
      final extractedHouse = _extractHouseNumber(widget.controller.text);
      if (extractedHouse.isNotEmpty) {
        house.text = extractedHouse;
      }
    }
  }

  /// Extracts house number from address string
  /// Enhanced version with multiple pattern matching
  String _extractHouseNumber(String address) {
    if (address.isEmpty) return '';

    final parts = address.split(',').map((e) => e.trim()).toList();

    // Patterns for house number detection
    final patterns = [
      // Standard numbers: 123, 12A, 12/3, 12-3
      RegExp(r'\b(\d+[A-Za-z]?(?:[/-]\d+)?)\b'),
      // With keywords: house 123, building 45, # 12
      RegExp(
        r'(?:house|home|building|bldg|uy|#)\s*(\d+[A-Za-z]?)',
        caseSensitive: false,
      ),
      // Street address pattern: "Street Name 123"
      RegExp(
        r"(?:ko'chasi|street|st\.?)\s+(\d+[A-Za-z]?)",
        caseSensitive: false,
      ),
    ];

    // Strategy 1: Check the first part (street address usually comes first)
    if (parts.isNotEmpty) {
      final firstPart = parts.first;
      for (var pattern in patterns) {
        final match = pattern.firstMatch(firstPart);
        if (match != null && match.groupCount > 0) {
          final houseNum = match.group(1) ?? '';
          if (houseNum.isNotEmpty && _isValidHouseNumber(houseNum)) {
            return houseNum;
          }
        }
      }
    }

    // Strategy 2: Check full address
    for (var pattern in patterns) {
      final match = pattern.firstMatch(address);
      if (match != null && match.groupCount > 0) {
        final houseNum = match.group(1) ?? '';
        if (houseNum.isNotEmpty && _isValidHouseNumber(houseNum)) {
          return houseNum;
        }
      }
    }

    return '';
  }

  /// Validates if the extracted number is a valid house number
  /// Filters out postal codes, phone numbers, etc.
  bool _isValidHouseNumber(String number) {
    // Remove letters for numeric check
    final numericPart = number.replaceAll(RegExp(r'[A-Za-z]'), '');
    if (numericPart.isEmpty) return false;

    final num = int.tryParse(numericPart);
    if (num == null) return false;

    // House numbers are typically 1-9999
    return num > 0 && num < 10000;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onAddressChanged);
    office.dispose();
    house.dispose();
    floor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewMapProvider);
    final event = ref.read(viewMapProvider.notifier);
    final colors = widget.colors;
    return Container(
      margin: MediaQuery.viewInsetsOf(context),
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      decoration: BoxDecoration(
        color: widget.colors.backgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.r),
          topLeft: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          8.verticalSpace,
          Container(
            width: 49.w,
            height: 3.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: AppStyle.dragElement,
            ),
          ),
          16.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppHelpers.getTranslation(TrKeys.enterADeliveryAddress),
              style: AppStyle.interNoSemi(
                size: 18,
                color: widget.colors.textBlack,
              ),
            ),
          ),
          24.verticalSpace,
          SearchTextField(
            isRead: true,
            isBorder: true,
            textEditingController: widget.controller,
            onTap: () async {
              // widget.onSearch();
            },
          ),
          24.verticalSpace,
          Form(
            key: fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedBorderTextField(
                  textController: office,
                  label: AppHelpers.getTranslation(TrKeys.title).toUpperCase(),
                  validation: (s) {
                    if (s?.isEmpty ?? true) {
                      return AppHelpers.getTranslation(TrKeys.canNotBeEmpty);
                    } else {
                      return null;
                    }
                  },
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedBorderTextField(
                        textController: house,
                        label: AppHelpers.getTranslation(
                          TrKeys.house,
                        ).toUpperCase(),
                      ),
                    ),
                    24.horizontalSpace,
                    Expanded(
                      child: OutlinedBorderTextField(
                        textController: floor,
                        label: AppHelpers.getTranslation(
                          TrKeys.floor,
                        ).toUpperCase(),
                      ),
                    ),
                  ],
                ),
                32.verticalSpace,
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.only(bottom: 28),
            child: CustomButton(
              isLoading: !widget.isShopLocation ? state.isLoading : false,
              background: !widget.isShopLocation
                  ? (state.isActive ? colors.primary : AppStyle.bgGrey)
                  : colors.primary,

              title: !widget.isShopLocation
                  ? (state.isActive
                        ? AppHelpers.getTranslation(TrKeys.apply)
                        : AppHelpers.getTranslation(TrKeys.noDriverZone))
                  : AppHelpers.getTranslation(TrKeys.apply),
              onPressed: () {
                if (widget.isShopLocation) {
                  Navigator.pop(context, state.place);
                } else {
                  if (state.isActive) {
                    ref.read(homeProvider.notifier)
                      ..fetchBannerPage(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..fetchRestaurantPage(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..fetchShopPageRecommend(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..fetchShopPage(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..fetchStorePage(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..fetchRestaurantPageNew(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..fetchCategoriesPage(
                        context,
                        RefreshController(),
                        isRefresh: true,
                      )
                      ..setAddress();
                    LocalStorage.setAddressSelected(
                      AddressData(
                        title: office.text,
                        address: state.place?.address?.address ?? "",
                        location: LocationModel(
                          latitude: state.place?.location?.first,
                          longitude: state.place?.location?.last,
                        ),
                      ),
                    );
                    AddressInformation data = AddressInformation(
                      address: widget.controller.text,
                      house: house.text,
                      floor: floor.text,
                    );
                    LocalStorage.setAddressInformation(data);
                    if (LocalStorage.getToken().isEmpty) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      return;
                    }
                    if (widget.address == null) {
                      event.saveLocation(
                        context,
                        onSuccess: () {
                          ref.read(profileProvider.notifier).fetchUser(context);
                          ref.read(homeProvider.notifier).setAddress();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      event.updateLocation(
                        context,
                        widget.address?.id,
                        onSuccess: () {
                          ref.read(profileProvider.notifier).fetchUser(context);
                          ref.read(homeProvider.notifier).setAddress();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    }
                  } else {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.noDriverZone),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
