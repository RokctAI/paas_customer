import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/application/profile/profile_notifier.dart';
import 'profile_state.dart';

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  () => ProfileNotifier(),
);
