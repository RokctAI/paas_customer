// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:booking_sdk/src/common/domain/interface/booking.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';

/// State of the customer's "My reservations" list.
class MyReservationsState {
  final bool isLoading;
  final List<ReservationData> reservations;

  /// Reservation whose cancel call is in flight (its button spins).
  final String? cancellingId;
  final String? error;

  const MyReservationsState({
    this.isLoading = false,
    this.reservations = const [],
    this.cancellingId,
    this.error,
  });

  MyReservationsState copyWith({
    bool? isLoading,
    List<ReservationData>? reservations,
    String? cancellingId,
    bool clearCancelling = false,
    String? error,
    bool clearError = false,
  }) =>
      MyReservationsState(
        isLoading: isLoading ?? this.isLoading,
        reservations: reservations ?? this.reservations,
        cancellingId:
            clearCancelling ? null : (cancellingId ?? this.cancellingId),
        error: clearError ? null : (error ?? this.error),
      );
}

class MyReservationsNotifier extends StateNotifier<MyReservationsState> {
  final BookingRepositoryFacade _repo;

  MyReservationsNotifier(this._repo) : super(const MyReservationsState());

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repo.getMyReservations();
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        state = state.copyWith(isLoading: false, reservations: data);
      case Failure(:final error):
        state = state.copyWith(isLoading: false, error: error);
    }
  }

  /// Cancels [id]; returns the failure message, or null on success.
  Future<String?> cancel(String id) async {
    state = state.copyWith(cancellingId: id, clearError: true);
    final result = await _repo.cancelReservation(id);
    if (!mounted) return null;
    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          clearCancelling: true,
          reservations: [
            for (final r in state.reservations)
              if (r.id == id)
                r.copyWith(status: data.status)
              else
                r,
          ],
        );
        return null;
      case Failure(:final error):
        state = state.copyWith(clearCancelling: true, error: error);
        return error;
    }
  }
}

final myReservationsProvider = StateNotifierProvider.autoDispose<
    MyReservationsNotifier, MyReservationsState>(
  (ref) => MyReservationsNotifier(GetIt.instance<BookingRepositoryFacade>()),
);
