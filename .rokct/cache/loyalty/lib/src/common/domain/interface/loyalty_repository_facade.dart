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
