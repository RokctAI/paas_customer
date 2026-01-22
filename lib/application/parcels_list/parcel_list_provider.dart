import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parcel_list_notifier.dart';
import 'parcel_list_state.dart';

final parcelListProvider =
    NotifierProvider<ParcelListNotifier, ParcelListState>(
      () => ParcelListNotifier(),
    );
