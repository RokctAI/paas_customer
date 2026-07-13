import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_notifier.dart';
import 'favorites_state.dart';

final favoritesProvider = NotifierProvider<FavoritesNotifier, FavoritesState>(
  () => FavoritesNotifier(),
);

