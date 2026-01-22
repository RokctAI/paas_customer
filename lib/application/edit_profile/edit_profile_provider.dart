import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_profile_notifier.dart';
import 'edit_profile_state.dart';

final editProfileProvider =
    NotifierProvider<EditProfileNotifier, EditProfileState>(
      () => EditProfileNotifier(),
    );
