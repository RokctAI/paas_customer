import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_notifier.dart';
import 'main_state.dart';

final mainProvider = NotifierProvider<MainNotifier, MainState>(
  () => MainNotifier(),
);
