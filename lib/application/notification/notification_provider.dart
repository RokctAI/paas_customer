import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_notifier.dart';
import 'notification_state.dart';

final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
      () => NotificationNotifier(),
    );
