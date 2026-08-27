// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
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

import 'package:base_sdk/base_sdk.dart';

import '../../domain/interface/loyalty_repository_facade.dart';
import '../../domain/models/loyalty_models.dart';

/// Offline default over base_sdk's shared database. Balances live in the
/// 'loyalty_accounts' box, the ledger in 'loyalty_transactions'.
class LocalLoyaltyRepository implements LoyaltyRepositoryFacade {
  static const String _accounts = 'loyalty_accounts';
  static const String _transactions = 'loyalty_transactions';

  @override
  Future<ApiResult<LoyaltyAccount>> getAccount({
    required String ownerId,
    String program = 'default',
  }) async {
    try {
      final id = '$program:$ownerId';
      final row = await AppDatabase().getItem(_accounts, id);
      final account = row != null
          ? LoyaltyAccount.fromJson(row)
          : LoyaltyAccount(
              accountId: id,
              ownerId: ownerId,
              program: program,
              balance: 0,
              updatedAt: DateTime.now(),
            );
      return ApiResult.success(data: account);
    } catch (e) {
      return ApiResult.failure(error: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ApiResult<List<LoyaltyTransaction>>> getTransactions(
    String accountId,
  ) async {
    try {
      final rows = await AppDatabase().getAll(_transactions);
      final list = rows
          .map(LoyaltyTransaction.fromJson)
          .where((t) => t.accountId == accountId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return ApiResult.success(data: list);
    } catch (e) {
      return ApiResult.failure(error: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ApiResult<LoyaltyAccount>> record(
    LoyaltyTransaction transaction,
  ) async {
    try {
      final db = AppDatabase();
      final row = await db.getItem(_accounts, transaction.accountId);
      if (row == null) {
        return const ApiResult.failure(
          error: 'Unknown loyalty account',
          statusCode: 404,
        );
      }
      final account = LoyaltyAccount.fromJson(row);
      final delta = switch (transaction.type) {
        LoyaltyTransactionType.earn => transaction.points,
        LoyaltyTransactionType.adjust => transaction.points,
        LoyaltyTransactionType.redeem => -transaction.points,
        LoyaltyTransactionType.expire => -transaction.points,
      };
      final newBalance = account.balance + delta;
      if (newBalance < 0) {
        return const ApiResult.failure(
          error: 'Insufficient loyalty balance',
          statusCode: 422,
        );
      }
      final updated =
          account.copyWith(balance: newBalance, updatedAt: DateTime.now());
      await db.putItem(
        _transactions,
        transaction.transactionId,
        transaction.toJson(),
      );
      await db.putItem(_accounts, updated.accountId, updated.toJson());
      return ApiResult.success(data: updated);
    } catch (e) {
      return ApiResult.failure(error: e.toString(), statusCode: 500);
    }
  }
}
