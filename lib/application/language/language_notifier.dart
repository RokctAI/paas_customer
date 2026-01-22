import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import 'language_state.dart';

class LanguageNotifier extends Notifier<LanguageState> {
  @override
  LanguageState build() => const LanguageState();

  void change(int index) {
    state = state.copyWith(index: index);
    LocalStorage.setLanguageData(state.list[index]);
  }

  Future<void> getLanguages(BuildContext context) async {
    final connect = await AppConnectivity.connectivity();
    if (connect) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await settingsRepository.getLanguages();
      response.when(
        success: (data) {
          final List<LanguageData> languages = data.data ?? [];
          final lang = LocalStorage.getLanguage();
          int index = 0;
          for (int i = 0; i < languages.length; i++) {
            if (languages[i].id == lang?.id) {
              index = i;
              break;
            }
          }
          state = state.copyWith(
            isLoading: false,
            list: data.data ?? [],
            index: index,
          );
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

  Future<void> makeSelectedLang(BuildContext context) async {
    LocalStorage.setLanguageSelected(true);
    LocalStorage.setLanguageData(state.list[state.index]);
    LocalStorage.setLangLtr(state.list[state.index].backward);
    await getTranslations(context);
  }

  Future<void> getTranslations(BuildContext context) async {
    final connect = await AppConnectivity.connectivity();
    if (connect) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await settingsRepository.getMobileTranslations();
      response.when(
        success: (data) {
          LocalStorage.setTranslations(data.data);
          state = state.copyWith(isLoading: false, isSuccess: true);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        context.replaceRoute(const NoConnectionRoute());
      }
    }
  }
}
