import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/trip_repository.dart';
import '../../domain/entities/trip.dart';
import '../../../sos/data/repositories/sos_repository.dart';

class TripState {
  final Trip? activeTrip;
  final List<Trip> history;
  final Duration countdown;
  final bool alertPending;
  const TripState({
    this.activeTrip,
    this.history = const <Trip>[],
    this.countdown = Duration.zero,
    this.alertPending = false,
  });
  TripState copyWith({
    Trip? activeTrip,
    List<Trip>? history,
    Duration? countdown,
    bool? alertPending,
    bool clearTrip = false,
  }) =>
      TripState(
        activeTrip: clearTrip ? null : (activeTrip ?? this.activeTrip),
        history: history ?? this.history,
        countdown: countdown ?? this.countdown,
        alertPending: alertPending ?? this.alertPending,
      );
}

class TripController extends StateNotifier<TripState> {
  final Ref _ref;
  Timer? _tick;
  Timer? _missedTimer;

  TripController(this._ref) : super(const TripState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final h = await _ref.read(tripRepositoryProvider).getHistory();
    if (!mounted) return;
    state = state.copyWith(history: h);
  }

  Future<void> startTrip({
    required String origin,
    required String destination,
    required int intervalMinutes,
  }) async {
    final now = DateTime.now();
    final checkIns = <CheckIn>[];
    DateTime next = now.add(Duration(minutes: intervalMinutes));
    for (int i = 0; i < 6; i++) {
      checkIns.add(CheckIn(
        id: 'ci_${now.millisecondsSinceEpoch}_$i',
        scheduledAt: next,
      ));
      next = next.add(Duration(minutes: intervalMinutes));
    }
    final trip = Trip(
      id: 't_${now.millisecondsSinceEpoch}',
      origin: origin,
      destination: destination,
      startedAt: now,
      expectedArrival: now.add(Duration(minutes: intervalMinutes * 6)),
      checkInIntervalMinutes: intervalMinutes,
      status: TripStatus.active,
      checkIns: checkIns,
    );
    final saved = await _ref.read(tripRepositoryProvider).saveTrip(trip);
    if (!mounted) return;
    state = state.copyWith(activeTrip: saved);
    _startTick();
  }

  void _startTick() {
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      final trip = state.activeTrip;
      if (trip == null || trip.status != TripStatus.active) return;
      final next = trip.nextCheckIn;
      if (next == null) return;
      final remaining = next.difference(DateTime.now());
      if (!mounted) return;
      state = state.copyWith(
        countdown: remaining.isNegative ? Duration.zero : remaining,
      );
    });
    _scheduleMissedCheck();
  }

  void _scheduleMissedCheck() {
    _missedTimer?.cancel();
    final trip = state.activeTrip;
    if (trip == null || trip.nextCheckIn == null) return;
    final dueIn = trip.nextCheckIn!.difference(DateTime.now());
    const gracePeriod = Duration(seconds: 30);
    _missedTimer = Timer(dueIn + gracePeriod, () {
      _onCheckInMissed();
    });
  }

  Future<void> _onCheckInMissed() async {
    final trip = state.activeTrip;
    if (trip == null || trip.status != TripStatus.active) return;
    final next = trip.nextCheckIn;
    if (next == null) return;
    final updatedCheckIns = trip.checkIns.map((c) {
      if (c.scheduledAt == next && c.acknowledgedAt == null && !c.triggered) {
        return c.copyWith(triggered: true);
      }
      return c;
    }).toList();
    final contacts = await _ref.read(sosRepositoryProvider).getContacts();
    final names = contacts.map((c) => c.name).toList();
    final updatedTrip = trip.copyWith(
      status: TripStatus.triggered,
      checkIns: updatedCheckIns,
      contactsNotified: names,
    );
    await _ref.read(tripRepositoryProvider).sendSmsToContacts(
          trip: updatedTrip,
          message:
              'EMERGENCY: ${trip.origin} -> ${trip.destination}. Check-in missed. Please verify safety.',
        );
    if (!mounted) return;
    state = state.copyWith(activeTrip: updatedTrip, alertPending: true);
    _stopTick();
  }

  Future<void> acknowledgeCheckIn() async {
    final trip = state.activeTrip;
    if (trip == null) return;
    final next = trip.nextCheckIn;
    if (next == null) return;
    final updatedCheckIns = trip.checkIns.map((c) {
      if (c.scheduledAt == next && c.acknowledgedAt == null) {
        return c.copyWith(acknowledgedAt: DateTime.now());
      }
      return c;
    }).toList();
    final updatedTrip = trip.copyWith(checkIns: updatedCheckIns, status: TripStatus.active);
    if (!mounted) return;
    state = state.copyWith(
      activeTrip: updatedTrip,
      alertPending: false,
      countdown: Duration.zero,
    );
    await _ref.read(tripRepositoryProvider).saveTrip(updatedTrip);
    _scheduleMissedCheck();
  }

  Future<void> cancelTrip() async {
    _stopTick();
    final trip = state.activeTrip;
    if (trip == null) {
      if (mounted) state = state.copyWith(clearTrip: true);
      return;
    }
    final updated = trip.copyWith(status: TripStatus.cancelled);
    await _ref.read(tripRepositoryProvider).saveTrip(updated);
    if (!mounted) return;
    state = state.copyWith(activeTrip: updated, clearTrip: true);
  }

  Future<void> completeTrip() async {
    _stopTick();
    final trip = state.activeTrip;
    if (trip == null) return;
    final updated = trip.copyWith(status: TripStatus.completed);
    await _ref.read(tripRepositoryProvider).saveTrip(updated);
    if (!mounted) return;
    state = state.copyWith(activeTrip: updated, clearTrip: true);
  }

  void _stopTick() {
    _tick?.cancel();
    _missedTimer?.cancel();
    _tick = null;
    _missedTimer = null;
  }

  @override
  void dispose() {
    _stopTick();
    super.dispose();
  }
}

final tripControllerProvider =
    StateNotifierProvider<TripController, TripState>((ref) => TripController(ref));
