import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/presentation/theme/theme_preference.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/address_old_data.dart';

import 'package:foodyman/infrastructure/services/services.dart';

import 'package:foodyman/domain/di/dependency_manager.dart';
import '../../presentation/pages/home/widgets/add_address.dart';
import '../../presentation/theme/color_set.dart';
import 'view_map_state.dart';

class ViewMapNotifier extends Notifier<ViewMapState> {
  @override
  ViewMapState build() => const ViewMapState();

  void scrolling(bool scroll) {
    state = state.copyWith(isScrolling: scroll);
  }

  void changePlace(AddressNewModel place) {
    state = state.copyWith(place: place, isSetAddress: true);
  }

  void checkAddress(BuildContext context) {
    AddressData? data = LocalStorage.getAddressSelected();
    if (data?.location?.latitude == null) {
      state = state.copyWith(isSetAddress: false);
      String themeKey;
      ThemePreference.create.then((value) {
        themeKey = value.getMode().name;

        CustomColorSet colors = CustomColorSet.createOrUpdate(
          themeKey == "light" ? CustomThemeMode.light : CustomThemeMode.dark,
        );
        if (context.mounted) {
          return AppHelpers.showAlertDialog(
            backgroundColor: colors.backgroundColor,
            context: context,
            child: AddAddress(colors: colors),
          );
        }
      });
    } else {
      state = state.copyWith(isSetAddress: true);
    }
  }

  void updateActive() {
    state = state.copyWith(isLoading: true);
  }

  Future<void> saveLocation(
    BuildContext context, {
    VoidCallback? onSuccess,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await userRepository.saveLocation(
        address: state.place?.copyWith(
          title: LocalStorage.getAddressSelected()?.title,
        ),
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          onSuccess?.call();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> updateLocation(
    BuildContext context,
    int? id, {
    VoidCallback? onSuccess,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await userRepository.updateLocation(
        address: state.place?.copyWith(
          title: LocalStorage.getAddressSelected()?.title,
        ),
        addressId: id,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          onSuccess?.call();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> checkDriverZone({
    required BuildContext context,
    required LatLng location,
    int? shopId,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isActive: false);
      final response = await shopsRepository.checkDriverZone(
        location,
        shopId: shopId,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, isActive: data);
          if (!data) {
            AppHelpers.showCheckTopSnackBarInfo(
              context,
              AppHelpers.getTranslation(TrKeys.noDriverZone),
            );
          }
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          if (!(status == 400 || status == 404)) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
