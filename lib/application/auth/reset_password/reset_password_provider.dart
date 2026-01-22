import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reset_password_notifier.dart';
import 'reset_password_state.dart';

final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      () => ResetPasswordNotifier(),
    );
