import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../domain/interface/loyalty_repository_facade.dart';
import 'loyalty_notifier.dart';
import 'loyalty_state.dart';

final loyaltyProvider = StateNotifierProvider<LoyaltyNotifier, LoyaltyState>(
  (ref) => LoyaltyNotifier(GetIt.I.get<LoyaltyRepositoryFacade>()),
);
