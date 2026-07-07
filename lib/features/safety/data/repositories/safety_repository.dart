import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/safety_score.dart';
import '../../domain/entities/safety_pulse.dart';

abstract class SafetyRepository {
  Future<SafetyScore> calculateDpsi({required double latitude, required double longitude});
  Stream<SafetyPulseAlert> safetyPulseStream();
}

class MockSafetyRepository implements SafetyRepository {
  static const _d = Duration(milliseconds: 400);
  @override
  Future<SafetyScore> calculateDpsi({required double latitude, required double longitude}) async {
    await Future<void>.delayed(_d);
    // Deterministic seeded by coords
    final seed = (latitude * 1000 + longitude * 1000).round();
    final rnd = Random(seed);
    final score = 50.0 + rnd.nextDouble() * 45.0;
    final level = score >= 75 ? DpsiLevel.safe : score >= 50 ? DpsiLevel.moderate : DpsiLevel.unsafe;
    final breakdown = DpsiBreakdown(
      factors: [
        RiskFactor(name: 'Lighting', weight: 0.3, description: 'Well-lit streets nearby'),
        RiskFactor(name: 'Time of day', weight: -0.1, description: 'Evening hours'),
        RiskFactor(name: 'Community reports', weight: 0.2, description: '2 reports in last 24h'),
        RiskFactor(name: 'Historical crime', weight: 0.15, description: 'Below city average'),
        RiskFactor(name: 'Foot traffic', weight: 0.4, description: 'Active area'),
      ],
      computedAt: DateTime.now(),
    );
    return SafetyScore(score: score, level: level, breakdown: breakdown, latitude: latitude, longitude: longitude);
  }

  @override
  Stream<SafetyPulseAlert> safetyPulseStream() async* {
    final messages = [
      SafetyPulseAlert(id: 'sp1', title: 'Safety Pulse', body: 'New community report near you', severity: SafetyPulseSeverity.info, timestamp: DateTime.now(), latitude: 19.07, longitude: 72.87),
      SafetyPulseAlert(id: 'sp2', title: 'Heads up', body: 'Streetlight reported broken on 5th Ave', severity: SafetyPulseSeverity.warning, timestamp: DateTime.now(), latitude: 19.08, longitude: 72.88),
      SafetyPulseAlert(id: 'sp3', title: 'Critical', body: 'Avoid the alley near park entrance', severity: SafetyPulseSeverity.critical, timestamp: DateTime.now(), latitude: 19.06, longitude: 72.86),
    ];
    for (final m in messages) {
      await Future<void>.delayed(const Duration(seconds: 8));
      yield m;
    }
  }
}

final safetyRepositoryProvider = Provider<SafetyRepository>((ref) => MockSafetyRepository());
