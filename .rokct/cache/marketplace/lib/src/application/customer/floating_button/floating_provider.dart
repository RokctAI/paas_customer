import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_sdk/src/application/customer/floating_button/floating_notifier.dart';
import 'package:marketplace_sdk/src/application/customer/floating_button/floating_state.dart';

final floatingProvider = StateNotifierProvider<FloatingNotifier, FloatingState>(
  (ref) => FloatingNotifier(),
);
