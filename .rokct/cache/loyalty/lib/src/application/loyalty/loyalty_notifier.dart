// Also brings ApiResult's pattern-matching helpers into scope: freezed >=3.1
// generates when/map as an EXTENSION (ApiResultPatterns) in base_sdk's
// api_result.freezed.dart, and extensions are only usable in libraries that
// import the declaring library - importing the facade alone is not enough.
import 'package:base_sdk/base_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/interface/loyalty_repository_facade.dart';
import '../../domain/models/loyalty_models.dart';
import 'loyalty_state.dart';

class LoyaltyNotifier extends StateNotifier<LoyaltyState> {
  final LoyaltyRepositoryFacade _repository;

  LoyaltyNotifier(this._repository) : super(const LoyaltyState());

  Future<void> fetchAccount({
    required String ownerId,
    String program = 'default',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repository.getAccount(ownerId: ownerId, program: program);
    await res.when(
      success: (account) async {
        final tx = await _repository.getTransactions(account.accountId);
        tx.when(
          success: (list) => state = state.copyWith(
            isLoading: false,
            account: account,
            transactions: list,
          ),
          failure: (error, statusCode) => state = state.copyWith(
            isLoading: false,
            account: account,
            error: error,
          ),
        );
      },
      failure: (error, statusCode) async =>
          state = state.copyWith(isLoading: false, error: error),
    );
  }

  Future<bool> record(LoyaltyTransaction transaction) async {
    final res = await _repository.record(transaction);
    return res.when(
      success: (account) {
        state = state.copyWith(
          account: account,
          transactions: [transaction, ...state.transactions],
        );
        return true;
      },
      failure: (error, statusCode) {
        state = state.copyWith(error: error);
        return false;
      },
    );
  }
}
