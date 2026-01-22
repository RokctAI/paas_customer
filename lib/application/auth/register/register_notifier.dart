import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import '../../../infrastructure/firebase_service/firebase_service.dart';
import 'register_state.dart';

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void setPassword(String password) {
    state = state.copyWith(password: password.trim(), isPasswordInvalid: false);
  }

  void setConfirmPassword(String password) {
    state = state.copyWith(
      confirmPassword: password.trim(),
      isConfirmPasswordInvalid: false,
    );
  }

  void setFirstName(String name) {
    state = state.copyWith(firstName: name.trim());
  }

  void setEmail(String value) {
    state = state.copyWith(email: value.trim(), isEmailInvalid: false);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value.trim());
  }

  void setLatName(String name) {
    state = state.copyWith(lastName: name.trim());
  }

  void setReferral(String name) {
    state = state.copyWith(referral: name.trim());
  }

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void toggleShowConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  bool checkEmail() {
    return AppValidators.isValidEmail(state.email);
  }

  Future<void> sendCode(BuildContext context, VoidCallback onSuccess) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!AppValidators.isValidEmail(state.email)) {
        state = state.copyWith(isEmailInvalid: true);
        return;
      }
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await authRepository.sigUp(email: state.email);
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, isSuccess: true);
          onSuccess();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, isSuccess: false);
          if (status == 400) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(TrKeys.emailAlreadyExists),
            );
          } else {
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

  Future<void> sendCodeToNumber(
    BuildContext context,
    ValueChanged<String> onSuccess,
  ) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      if (AppConstants.isPhoneFirebase) {
        FirebaseService.sendCode(
          phone: state.email,
          onSuccess: (id) {
            state = state.copyWith(
              verificationId: id,
              phone: state.email,
              isLoading: false,
              isSuccess: true,
            );
            onSuccess(id);
          },
          onError: (r) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(r),
            );
            state = state.copyWith(isLoading: false, isSuccess: false);
          },
        );
      } else {
        final response = await authRepository.sendOtp(phone: state.email);
        response.when(
          success: (success) {
            state = state.copyWith(
              verificationId: success.data?.verifyId ?? '',
              phone: state.email,
              isLoading: false,
              isSuccess: true,
            );
            onSuccess(success.data?.verifyId ?? '');
          },
          failure: (failure, status) {
            AppHelpers.showCheckTopSnackBar(context, failure);
            state = state.copyWith(isLoading: false, isSuccess: false);
          },
        );
      }
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> register(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordInvalid: true);
        return;
      }
      if (!AppValidators.isValidConfirmPassword(
        state.password,
        state.confirmPassword,
      )) {
        state = state.copyWith(isConfirmPasswordInvalid: true);
        return;
      }
      state = state.copyWith(isLoading: true);
      final response = await authRepository.sigUpWithData(
        user: UserModel(
          email: state.email,
          firstname: state.firstName,
          lastname: state.lastName,
          phone: state.phone,
          password: state.password,
          confirmPassword: state.confirmPassword,
          referral: state.referral,
        ),
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          LocalStorage.setToken(data.token);
          _success(context);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> registerWithFirebase(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordInvalid: true);
        return;
      }
      if (!AppValidators.isValidConfirmPassword(
        state.password,
        state.confirmPassword,
      )) {
        state = state.copyWith(isConfirmPasswordInvalid: true);
        return;
      }
      state = state.copyWith(isLoading: true);
      final response = await authRepository.sigUpWithPhone(
        user: UserModel(
          email: state.email,
          firstname: state.firstName,
          lastname: state.lastName,
          phone: state.phone,
          password: state.password,
          confirmPassword: state.confirmPassword,
          referral: state.referral,
        ),
      );

      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          LocalStorage.setToken(data.token);
          _success(context, addresses: data.user?.addresses);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          if (status == 400) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(
                AppHelpers.getTranslation(TrKeys.referralIncorrect),
              ),
            );
          } else {
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

  Future<void> registerWithPhone(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordInvalid: true);
        return;
      }
      if (!AppValidators.isValidConfirmPassword(
        state.password,
        state.confirmPassword,
      )) {
        state = state.copyWith(isConfirmPasswordInvalid: true);
        return;
      }
      state = state.copyWith(isLoading: true);
      final response = await userRepository.editProfile(
        user: EditProfile(
          // email: state.email,
          firstname: state.firstName,
          lastname: state.lastName,
          phone: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          referral: state.referral,
        ),
      );

      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          _success(context);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          if (status == 400) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(
                AppHelpers.getTranslation(TrKeys.referralIncorrect),
              ),
            );
          } else {
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

  Future<void> loginWithSocial(BuildContext context, IconData type) async {
    state = state.copyWith(isLoading: true);
    Either<UserCredential, dynamic>? user;
    switch (type) {
      case FlutterRemix.apple_fill:
        user = await FirebaseService.socialApple();
        break;
      case FlutterRemix.google_fill:
        user = await FirebaseService.socialGoogle();
        break;
      case FlutterRemix.facebook_fill:
        user = await FirebaseService.socialFacebook();
        break;
    }

    user?.fold(
      (l) async {
        String? token = await l.user?.getIdToken();
        if (token == null) return;
        final response = await authRepository.loginWithSocial(
          email: l.user?.email,
          displayName: l.user?.displayName,
          id: token,
          avatar: l.user?.photoURL,
        );
        response.when(
          success: (data) async {
            LocalStorage.setToken(data.data?.accessToken ?? '');
            _success(context, addresses: data.data?.user?.addresses);
            state = state.copyWith(isLoading: false);
          },
          failure: (failure, status) {
            state = state.copyWith(isLoading: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      },
      (failure) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<void> _success(
    BuildContext context, {
    List<AddressNewModel>? addresses,
  }) async {
    if (addresses?.isNotEmpty ?? false) {
      final AddressNewModel? model = addresses?.firstWhere(
        (e) => e.active ?? false,
        orElse: () => AddressNewModel(),
      );
      userRepository.saveLocation(
        address: AddressNewModel(
          title: LocalStorage.getAddressSelected()?.title,
          address: AddressInformation(
            address: LocalStorage.getAddressSelected()?.address,
          ),
          location: [
            LocalStorage.getAddressSelected()?.location?.longitude,
            LocalStorage.getAddressSelected()?.location?.latitude,
          ],
        ),
      );
      LocalStorage.setAddressSelected(
        AddressData(
          title: model?.title ?? "",
          address: model?.address?.address ?? "",
          location: LocationModel(
            longitude: model?.location?.last,
            latitude: model?.location?.first,
          ),
        ),
      );
    }
    context.router.popUntilRoot();
    context.replaceRoute(MainRoute());
    String? fcmToken = await FirebaseService.getFcmToken();
    userRepository.updateFirebaseToken(fcmToken);
  }
}
