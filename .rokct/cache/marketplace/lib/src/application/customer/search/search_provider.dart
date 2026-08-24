import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_sdk/src/di/injection.dart';

import 'package:marketplace_sdk/src/application/customer/search/search_notifier.dart';
import 'package:marketplace_sdk/src/application/customer/search/search_state.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(shopsRepository, productsRepository),
);
