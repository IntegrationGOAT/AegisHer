import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getHistory();
  Future<bool> sendSmsToContacts({required Trip trip, required String message});
  Future<Trip> saveTrip(Trip trip);
}

class MockTripRepository implements TripRepository {
  final List<Trip> _history = <Trip>[];
  static const _d = Duration(milliseconds: 300);

  @override
  Future<List<Trip>> getHistory() async {
    await Future<void>.delayed(_d);
    return List<Trip>.unmodifiable(_history);
  }

  @override
  Future<bool> sendSmsToContacts({required Trip trip, required String message}) async {
    await Future<void>.delayed(_d);
    // ignore: avoid_print
    print('[SafetyPulse] SMS (STUB): "$message" | trip=${trip.origin} -> ${trip.destination}');
    return true;
  }

  @override
  Future<Trip> saveTrip(Trip trip) async {
    await Future<void>.delayed(_d);
    _history.add(trip);
    return trip;
  }
}

final tripRepositoryProvider = Provider<TripRepository>((ref) => MockTripRepository());
