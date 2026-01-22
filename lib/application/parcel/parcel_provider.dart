import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parcel_notifier.dart';
import 'parcel_state.dart';

final parcelProvider = NotifierProvider<ParcelNotifier, ParcelState>(
  () => ParcelNotifier(),
);
