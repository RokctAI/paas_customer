import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paas_customer/domain/di/dependency_manager.dart';

import 'delivery_points_notifier.dart';
import 'delivery_points_state.dart';

final deliveryPointsProvider =
    StateNotifierProvider<DeliveryPointsNotifier, DeliveryPointsState>(
  (ref) => DeliveryPointsNotifier(deliveryPointsRepository),
);
