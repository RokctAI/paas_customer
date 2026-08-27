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

/// Core loyalty domain objects. Deliberately backend-agnostic: points,
/// cashback and stamp-card programs all reduce to an account balance plus an
/// append-only transaction ledger.
class LoyaltyAccount {
  final String accountId;
  final String ownerId;
  final String program;
  final double balance;
  final DateTime updatedAt;

  const LoyaltyAccount({
    required this.accountId,
    required this.ownerId,
    required this.program,
    required this.balance,
    required this.updatedAt,
  });

  LoyaltyAccount copyWith({double? balance, DateTime? updatedAt}) {
    return LoyaltyAccount(
      accountId: accountId,
      ownerId: ownerId,
      program: program,
      balance: balance ?? this.balance,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'ownerId': ownerId,
        'program': program,
        'balance': balance,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory LoyaltyAccount.fromJson(Map<String, dynamic> json) => LoyaltyAccount(
        accountId: json['accountId'] as String? ?? json['id'] as String,
        ownerId: json['ownerId'] as String? ?? '',
        program: json['program'] as String? ?? 'default',
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

enum LoyaltyTransactionType { earn, redeem, adjust, expire }

class LoyaltyTransaction {
  final String transactionId;
  final String accountId;
  final LoyaltyTransactionType type;
  final double points;
  final String? reference;
  final DateTime createdAt;

  const LoyaltyTransaction({
    required this.transactionId,
    required this.accountId,
    required this.type,
    required this.points,
    this.reference,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'accountId': accountId,
        'type': type.name,
        'points': points,
        'reference': reference,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) =>
      LoyaltyTransaction(
        transactionId:
            json['transactionId'] as String? ?? json['id'] as String,
        accountId: json['accountId'] as String? ?? '',
        type: LoyaltyTransactionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => LoyaltyTransactionType.adjust,
        ),
        points: (json['points'] as num?)?.toDouble() ?? 0,
        reference: json['reference'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
