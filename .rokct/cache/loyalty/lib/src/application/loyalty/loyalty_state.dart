import '../../domain/models/loyalty_models.dart';

class LoyaltyState {
  final bool isLoading;
  final LoyaltyAccount? account;
  final List<LoyaltyTransaction> transactions;
  final String? error;

  const LoyaltyState({
    this.isLoading = false,
    this.account,
    this.transactions = const [],
    this.error,
  });

  LoyaltyState copyWith({
    bool? isLoading,
    LoyaltyAccount? account,
    List<LoyaltyTransaction>? transactions,
    String? error,
  }) {
    return LoyaltyState(
      isLoading: isLoading ?? this.isLoading,
      account: account ?? this.account,
      transactions: transactions ?? this.transactions,
      error: error,
    );
  }
}
