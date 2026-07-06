enum SafetyLevel {
  safe,
  moderate,
  unsafe,
  unknown;

  String get label {
    switch (this) {
      case SafetyLevel.safe:
        return 'Safe';
      case SafetyLevel.moderate:
        return 'Moderate';
      case SafetyLevel.unsafe:
        return 'Unsafe';
      case SafetyLevel.unknown:
        return 'Unknown';
    }
  }
}

class SafetyScore {
  final double score;
  final SafetyLevel level;
  final List<String> factors;
  final DateTime timestamp;

  SafetyScore({
    required this.score,
    required this.level,
    required this.factors,
    required this.timestamp,
  });

  factory SafetyScore.fromJson(Map<String, dynamic> json) {
    return SafetyScore(
      score: json['score'] as double,
      level: SafetyLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => SafetyLevel.unknown,
      ),
      factors: List<String>.from(json['factors'] ?? []),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level.name,
      'factors': factors,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SafetyScore.initial() {
    return SafetyScore(
      score: 0.0,
      level: SafetyLevel.unknown,
      factors: [],
      timestamp: DateTime.now(),
    );
  }
}