import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'filter_notifier.dart';
import 'filter_state.dart';

final filterProvider =
    NotifierProvider.autoDispose<FilterNotifier, FilterState>(
      () => FilterNotifier(),
    );
