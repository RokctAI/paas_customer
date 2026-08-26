// Copyright (c) 2026 RokctAI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
