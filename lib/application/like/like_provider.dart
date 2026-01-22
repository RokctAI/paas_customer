import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'like_notifier.dart';
import 'like_state.dart';

final likeProvider = NotifierProvider<LikeNotifier, LikeState>(
  () => LikeNotifier(),
);
