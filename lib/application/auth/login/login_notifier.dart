import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/firebase_service/firebase_service.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setAgreedToTerms(bool agree) {
    state = state.copyWith(isAgreedToTerms: agree);
  }

  void setPassword(String text) {
    state = state.copyWith(
      password: text.trim(),
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setEmail(String text) {
    state = state.copyWith(
      email: text.trim(),
      phone: '',
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setPhone(String text) {
    state = state.copyWith(
      phone: text.trim(),
      email: '',
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setShowPassword(bool show) {
    state = state.copyWith(showPassword: show);
  }

  void setKeepLogin(bool keep) {
    state = state.copyWith(isKeepLogin: keep);
  }

  Future<void> checkLanguage(BuildContext context) async {
    final lang = LocalStorage.getLanguage();
    if (lang == null) {
      state = state.copyWith(isSelectLanguage: false);
    } else {
      final connect = await AppConnectivity.connectivity();
      if (connect) {
        final response = await settingsRepository.getLanguages();
        response.when(
          success: (data) {
            state = state.copyWith(list: data.data ?? []);
            final List<LanguageData> languages = data.data ?? [];
            for (int i = 0; i < languages.length; i++) {
              if (languages[i].id == lang.id) {
                state = state.copyWith(isSelectLanguage: true);
                break;
              }
            }
          },
          failure: (failure, status) {
            state = state.copyWith(isSelectLanguage: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      } else {
        if (context.mounted) {
          AppHelpers.showNoConnectionSnackBar(context);
        }
      }
    }
  }

  bool checkEmail() {
    return AppValidators.checkEmail(state.email) && state.email.isNotEmpty;
  }

  Future<void> login(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (checkEmail()) {
        if (!AppValidators.isValidEmail(state.email)) {
          state = state.copyWith(isEmailNotValid: true);
          return;
        }
      }

      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordNotValid: true);
        return;
      }
      state = state.copyWith(isLoading: true);
      final response = await authRepository.login(
        email: state.email,
        phone: state.phone,
        password: state.password,
      );
      response.when(
        success: (data) async {
          LocalStorage.setToken(data.data?.accessToken ?? '');
          _success(context, data.data?.user);
          state = state.copyWith(isLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, isLoginError: true);
          AppHelpers.showCheckTopSnackBar(context, failure);
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
            _success(context, data.data?.user);
            state = state.copyWith(isLoading: false);
          },
          failure: (failure, status) {
            state = state.copyWith(isLoading: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      },
      (r) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, r);
      },
    );
  }

  Future<void> _success(BuildContext context, UserModel? user) async {
    final AddressNewModel? model = user?.addresses?.firstWhere(
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
    if (user?.addresses?.isNotEmpty ?? false) {
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
