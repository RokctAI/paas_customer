import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/services.dart';

import 'package:foodyman/domain/di/dependency_manager.dart';
import 'help_state.dart';

class HelpNotifier extends Notifier<HelpState> {
  @override
  HelpState build() => const HelpState();

  Future<void> fetchHelp(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await settingsRepository.getFaq();
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, data: data);
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
}
