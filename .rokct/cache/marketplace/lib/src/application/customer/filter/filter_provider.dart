import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_sdk/src/di/injection.dart';
import 'package:marketplace_sdk/src/application/customer/filter/filter_notifier.dart';
import 'package:marketplace_sdk/src/application/customer/filter/filter_state.dart';

final filterProvider =
    StateNotifierProvider.autoDispose<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(shopsRepository),
);
