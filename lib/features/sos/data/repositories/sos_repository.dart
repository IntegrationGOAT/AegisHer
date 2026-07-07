import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sos_event.dart';

abstract class SosRepository {
  Future<List<SosContact>> getContacts();
  Future<bool> dispatch(SosEvent event);
  Future<bool> notifyContacts(SosEvent event, List<SosContact> contacts);
  Future<void> addContact(SosContact contact);
}

class MockSosRepository implements SosRepository {
  final List<SosContact> _contacts = [
    const SosContact(id: 'c1', name: 'Mom', phone: '+91 98765 43210', relationship: 'Family'),
    const SosContact(id: 'c2', name: 'Best Friend', phone: '+91 98765 11111', relationship: 'Friend'),
    const SosContact(id: 'c3', name: 'Local Police', phone: '100', relationship: 'Emergency'),
  ];
  static const _d = Duration(milliseconds: 400);

  @override Future<List<SosContact>> getContacts() async { await Future<void>.delayed(_d); return _contacts; }
  @override Future<bool> dispatch(SosEvent event) async {
    await Future<void>.delayed(_d);
    // ignore: avoid_print
    print('[SOS] Dispatch (STUB): lat=${event.latitude} lng=${event.longitude}');
    return true;
  }
  @override Future<bool> notifyContacts(SosEvent event, List<SosContact> contacts) async {
    await Future<void>.delayed(_d);
    for (final c in contacts) {
      // ignore: avoid_print
      print('[SOS] Notify ${c.name} (${c.phone})');
    }
    return true;
  }
  @override Future<void> addContact(SosContact contact) async { await Future<void>.delayed(_d); _contacts.add(contact); }
}

final sosRepositoryProvider = Provider<SosRepository>((ref) => MockSosRepository());
