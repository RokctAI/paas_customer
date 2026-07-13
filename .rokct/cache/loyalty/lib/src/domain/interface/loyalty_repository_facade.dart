import 'package:base_sdk/base_sdk.dart';

import '../models/loyalty_models.dart';

/// Consumer-owned boundary for loyalty persistence/transport.
///
/// The host app registers a backend-backed implementation when the platform
/// exposes loyalty endpoints; a local offline implementation over base_sdk's
/// shared database ships with this SDK as the default.
abstract class LoyaltyRepositoryFacade {
  Future<ApiResult<LoyaltyAccount>> getAccount({
    required String ownerId,
    String program,
  });

  Future<ApiResult<List<LoyaltyTransaction>>> getTransactions(
    String accountId,
  );

  /// Records a transaction and returns the account with its updated balance.
  Future<ApiResult<LoyaltyAccount>> record(LoyaltyTransaction transaction);
}
