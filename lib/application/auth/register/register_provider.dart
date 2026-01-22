import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_notifier.dart';
import 'register_state.dart';

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  () => RegisterNotifier(),
);
