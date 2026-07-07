import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../safety/data/repositories/safety_repository.dart';
import '../../data/repositories/sos_repository.dart';
import '../../domain/entities/sos_event.dart';
import '../../../../services/location_service.dart';

class SosState {
  final SosStatus status;
  final SosEvent? event;
  final List<SosContact> contacts;
  final int countdown;
  final List<String> evidenceLog;
  const SosState({this.status = SosStatus.idle, this.event, this.contacts = const [], this.countdown = 0, this.evidenceLog = const []});
  SosState copyWith({SosStatus? status, SosEvent? event, List<SosContact>? contacts, int? countdown, List<String>? evidenceLog}) =>
      SosState(status: status ?? this.status, event: event ?? this.event, contacts: contacts ?? this.contacts, countdown: countdown ?? this.countdown, evidenceLog: evidenceLog ?? this.evidenceLog);
}

class SosController extends StateNotifier<SosState> {
  final Ref _ref;
  Timer? _timer;
  SosController(this._ref) : super(const SosState()) { _load(); }
  Future<void> _load() async { final c = await _ref.read(sosRepositoryProvider).getContacts(); if (mounted) state = state.copyWith(contacts: c); }

  void startCountdown() {
    if (state.status != SosStatus.idle && state.status != SosStatus.cancelled) return;
    state = state.copyWith(status: SosStatus.countdown, countdown: 3, evidenceLog: const []);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (state.countdown <= 1) { t.cancel(); activate(); }
      else state = state.copyWith(countdown: state.countdown - 1);
    });
  }

  Future<void> activate() async {
    _timer?.cancel();
    final loc = await LocationService().getCurrentLocation();
    final evidence = <String>[
      'Location captured (${(loc['latitude'] ?? 0).toStringAsFixed(4)}, ${(loc['longitude'] ?? 0).toStringAsFixed(4)})',
      'Audio recording started (mock)',
      'Sensor snapshot captured (mock)',
    ];
    final event = SosEvent(id: 'sos_${DateTime.now().millisecondsSinceEpoch}', status: SosStatus.active, startedAt: DateTime.now(), latitude: loc['latitude'] ?? 0, longitude: loc['longitude'] ?? 0, evidence: [SosEvidence(type: 'location', data: {'lat': loc['latitude'], 'lng': loc['longitude']}, capturedAt: DateTime.now())], contactsNotified: const []);
    if (!mounted) return;
    state = state.copyWith(status: SosStatus.active, event: event, evidenceLog: evidence);
    await _ref.read(sosRepositoryProvider).dispatch(event);
    await _ref.read(sosRepositoryProvider).notifyContacts(event, state.contacts);
    if (!mounted) return;
    state = state.copyWith(event: SosEvent(id: event.id, status: SosStatus.active, startedAt: event.startedAt, latitude: event.latitude, longitude: event.longitude, evidence: event.evidence, contactsNotified: state.contacts.map((c) => c.name).toList()));
  }

  void cancel() { _timer?.cancel(); if (mounted) state = state.copyWith(status: SosStatus.cancelled, countdown: 0); }
  void reset() { state = state.copyWith(status: SosStatus.idle, countdown: 0, evidenceLog: const [], event: null); }
  @override void dispose() { _timer?.cancel(); super.dispose(); }
}

final sosControllerProvider = StateNotifierProvider<SosController, SosState>((ref) => SosController(ref));
