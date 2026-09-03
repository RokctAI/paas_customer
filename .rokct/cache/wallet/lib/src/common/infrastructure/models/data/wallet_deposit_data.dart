// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

/// Typed shapes for wallet's `api.wallet.*` deposit endpoints (pay
/// `wallet/frappe/src/tenant/api/wallet.py`). Hand-written, no codegen, so
/// the package stays analyzable without a build_runner pass — the same
/// stance as the sibling SDKs' response records.
library;

/// The doctype's `method` Select, verbatim (`wallet_deposit_request.json`).
abstract final class WalletDepositMethod {
  static const String bankDeposit = 'Bank Deposit';
  static const String eft = 'EFT';
}

/// The doctype's `status` Select, verbatim: Draft / Pending / Approved /
/// Rejected. [unknown] exists so a status added server-side later renders
/// as an unlabelled row instead of throwing on a money screen.
enum WalletDepositStatus {
  draft,
  pending,
  approved,
  rejected,
  unknown;

  static WalletDepositStatus parse(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'draft':
        return WalletDepositStatus.draft;
      case 'pending':
        return WalletDepositStatus.pending;
      case 'approved':
        return WalletDepositStatus.approved;
      case 'rejected':
        return WalletDepositStatus.rejected;
      default:
        return WalletDepositStatus.unknown;
    }
  }

  /// Still waiting on a person — the only live state.
  bool get isLive => this == WalletDepositStatus.pending;

  /// Approved or Rejected: immutable server-side (`TERMINAL_STATUSES`).
  bool get isTerminal =>
      this == WalletDepositStatus.approved || this == WalletDepositStatus.rejected;
}

num _num(dynamic value) =>
    value is num ? value : num.tryParse('${value ?? ''}') ?? 0;

String? _text(dynamic value) {
  final text = value?.toString().trim();
  return (text == null || text.isEmpty) ? null : text;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString().trim().replaceFirst(' ', 'T'));
}

Map<String, dynamic> _map(dynamic body) {
  final data = body is Map && body.containsKey('message') ? body['message'] : body;
  return data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
}

/// Where the money physically goes — `get_deposit_destination`, the
/// `Wallet Deposit Settings` Single served in full. [accountNumber] is the
/// whole number because a payer at an ATM has to copy it; mask it on
/// screen with [maskedAccountNumber].
class WalletDepositDestination {
  const WalletDepositDestination({
    required this.accepting,
    this.accountHolderName,
    this.bankName,
    this.accountNumber,
    this.branchCode,
    this.accountType,
    this.instructions,
    this.methods = const [WalletDepositMethod.bankDeposit, WalletDepositMethod.eft],
  });

  factory WalletDepositDestination.fromJson(dynamic body) {
    final json = _map(body);
    final methods = json['methods'];
    return WalletDepositDestination(
      accepting: json['accepting'] == true || json['accepting'] == 1,
      accountHolderName: _text(json['account_holder_name']),
      bankName: _text(json['bank_name']),
      accountNumber: _text(json['account_number']),
      branchCode: _text(json['branch_code']),
      accountType: _text(json['account_type']),
      instructions: _text(json['instructions']),
      methods: methods is List
          ? methods.map((m) => m.toString()).toList(growable: false)
          : const [WalletDepositMethod.bankDeposit, WalletDepositMethod.eft],
    );
  }

  /// False when the tenant switched bank deposits off OR has not configured
  /// an account yet — either way there is nowhere to pay into.
  final bool accepting;
  final String? accountHolderName;
  final String? bankName;
  final String? accountNumber;
  final String? branchCode;
  final String? accountType;
  final String? instructions;
  final List<String> methods;

  /// `•••• 4417` — the app's manners for a number that is not a secret.
  String get maskedAccountNumber {
    final digits = (accountNumber ?? '').trim();
    if (digits.length <= 4) return digits;
    return '•••• ${digits.substring(digits.length - 4)}';
  }
}

/// One `Wallet Deposit Request` row as `list_deposit_requests` /
/// `list_pending_deposit_requests` serve it.
class WalletDepositRecord {
  const WalletDepositRecord({
    required this.id,
    required this.amount,
    required this.status,
    this.method,
    this.reference,
    this.slipUrl,
    this.note,
    this.rejectionReason,
    this.balanceAtSubmit,
    this.submittedAt,
    this.resolvedAt,
    this.credited = false,
    this.userId,
    this.userName,
  });

  factory WalletDepositRecord.fromJson(Map<String, dynamic> json) =>
      WalletDepositRecord(
        id: json['id']?.toString() ?? '',
        amount: _num(json['amount']),
        status: WalletDepositStatus.parse(json['status']),
        method: _text(json['method']),
        reference: _text(json['reference']),
        slipUrl: _text(json['slip']),
        note: _text(json['note']),
        rejectionReason: _text(json['rejection_reason']),
        balanceAtSubmit:
            json['balance_at_submit'] == null ? null : _num(json['balance_at_submit']),
        submittedAt: _date(json['submitted_at']),
        resolvedAt: _date(json['resolved_at']),
        credited: json['credited'] == true || _num(json['credited']) == 1,
        userId: _text(json['user']),
        userName: _text(json['user_name']),
      );

  /// Every row of a list answer. Both list defs return a BARE list; anything
  /// else parses to no rows — a payer who has never deposited has none.
  static List<WalletDepositRecord> listFrom(dynamic body) {
    final data = body is Map && body.containsKey('message') ? body['message'] : body;
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((row) => WalletDepositRecord.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  final String id;
  final num amount;
  final WalletDepositStatus status;
  final String? method;

  /// The string the approver matches the slip against — the one thing a
  /// payer reads out on the phone to the office.
  final String? reference;
  final String? slipUrl;
  final String? note;

  /// In words, and only on a Rejected row: the controller refuses a
  /// rejection without one.
  final String? rejectionReason;
  final num? balanceAtSubmit;
  final DateTime? submittedAt;
  final DateTime? resolvedAt;

  /// The approved amount has landed in the wallet (at most once).
  final bool credited;

  /// Only on the approver's queue: who paid.
  final String? userId;
  final String? userName;

  bool get isLive => status.isLive;
}

/// `submit_deposit_request`'s answer. [balance] is the wallet AS IT STANDS
/// — the pending deposit is NOT subtracted, and the client must not either.
class WalletDepositSubmitResponse {
  const WalletDepositSubmitResponse({
    required this.success,
    this.requestId,
    this.reference,
    this.amount,
    this.method,
    this.status = WalletDepositStatus.pending,
    this.submittedAt,
    this.balance,
  });

  factory WalletDepositSubmitResponse.fromJson(dynamic body) {
    final json = _map(body);
    return WalletDepositSubmitResponse(
      success: json['success'] == true,
      requestId: _text(json['request_id']),
      reference: _text(json['reference']),
      amount: json['amount'] == null ? null : _num(json['amount']),
      method: _text(json['method']),
      status: WalletDepositStatus.parse(json['status'] ?? 'Pending'),
      submittedAt: _date(json['submitted_at']),
      balance: json['balance'] == null ? null : _num(json['balance']),
    );
  }

  final bool success;
  final String? requestId;
  final String? reference;
  final num? amount;
  final String? method;
  final WalletDepositStatus status;
  final DateTime? submittedAt;
  final num? balance;
}

/// `approve_deposit_request` / `reject_deposit_request`'s answer.
class WalletDepositResolution {
  const WalletDepositResolution({
    required this.requestId,
    required this.status,
    this.amount,
    this.newBalance,
    this.reason,
  });

  factory WalletDepositResolution.fromJson(dynamic body) {
    final json = _map(body);
    final approved = json['approved'] == true;
    final rejected = json['rejected'] == true;
    return WalletDepositResolution(
      requestId: _text(json['request_id']) ?? '',
      status: approved
          ? WalletDepositStatus.approved
          : (rejected ? WalletDepositStatus.rejected : WalletDepositStatus.unknown),
      amount: json['amount'] == null ? null : _num(json['amount']),
      newBalance: json['new_balance'] == null ? null : _num(json['new_balance']),
      reason: _text(json['reason']),
    );
  }

  final String requestId;
  final WalletDepositStatus status;
  final num? amount;

  /// The payer's balance after the credit — approvals only.
  final num? newBalance;
  final String? reason;
}
