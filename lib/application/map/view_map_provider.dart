import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view_map_notifier.dart';
import 'view_map_state.dart';

final viewMapProvider = NotifierProvider<ViewMapNotifier, ViewMapState>(
  () => ViewMapNotifier(),
);
