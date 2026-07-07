enum TripStatus { idle, active, completed, triggered, cancelled }

class CheckIn {
  final String id;
  final DateTime scheduledAt;
  final DateTime? acknowledgedAt;
  final bool triggered;
  const CheckIn({
    required this.id,
    required this.scheduledAt,
    this.acknowledgedAt,
    this.triggered = false,
  });
  CheckIn copyWith({DateTime? acknowledgedAt, bool? triggered}) => CheckIn(
        id: id,
        scheduledAt: scheduledAt,
        acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
        triggered: triggered ?? this.triggered,
      );
}

class Trip {
  final String id;
  final String origin;
  final String destination;
  final DateTime startedAt;
  final DateTime expectedArrival;
  final int checkInIntervalMinutes;
  final TripStatus status;
  final List<CheckIn> checkIns;
  final List<String> contactsNotified;
  const Trip({
    required this.id,
    required this.origin,
    required this.destination,
    required this.startedAt,
    required this.expectedArrival,
    required this.checkInIntervalMinutes,
    this.status = TripStatus.idle,
    this.checkIns = const [],
    this.contactsNotified = const [],
  });
  Trip copyWith({
    TripStatus? status,
    List<CheckIn>? checkIns,
    List<String>? contactsNotified,
  }) =>
      Trip(
        id: id,
        origin: origin,
        destination: destination,
        startedAt: startedAt,
        expectedArrival: expectedArrival,
        checkInIntervalMinutes: checkInIntervalMinutes,
        status: status ?? this.status,
        checkIns: checkIns ?? this.checkIns,
        contactsNotified: contactsNotified ?? this.contactsNotified,
      );
  DateTime? get nextCheckIn {
    final pending = checkIns
        .where((c) => c.acknowledgedAt == null && !c.triggered)
        .toList();
    if (pending.isEmpty) return null;
    pending.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return pending.first.scheduledAt;
  }
}
