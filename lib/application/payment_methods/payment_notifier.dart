import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'payment_state.dart';

class PaymentNotifier extends Notifier<PaymentState> {
  @override
  PaymentState build() => const PaymentState();

  void change(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> fetchPayments(
    BuildContext context, {
    bool withOutCash = false,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isPaymentsLoading: true);
      final response = await paymentsRepository.getPayments();
      response.when(
        success: (data) {
          List payments = [];
          if (withOutCash) {
            payments =
                data?.data?.reversed.where((e) => e.tag != "cash").toList() ??
                [];
          } else {
            payments = data?.data?.reversed.toList() ?? [];
          }
          state = state.copyWith(payments: payments, isPaymentsLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isPaymentsLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
