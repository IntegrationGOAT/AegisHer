enum DpsiLevel { safe, moderate, unsafe, unknown }

class RiskFactor {
  final String name;
  final double weight; // -1..1
  final String description;
  const RiskFactor({required this.name, required this.weight, required this.description});
}

class DpsiBreakdown {
  final List<RiskFactor> factors;
  final DateTime computedAt;
  const DpsiBreakdown({required this.factors, required this.computedAt});
}

class SafetyScore {
  final double score; // 0..100
  final DpsiLevel level;
  final DpsiBreakdown breakdown;
  final double latitude;
  final double longitude;
  const SafetyScore({required this.score, required this.level, required this.breakdown, required this.latitude, required this.longitude});
  String get levelLabel {
    switch (level) {
      case DpsiLevel.safe: return 'Safe';
      case DpsiLevel.moderate: return 'Moderate';
      case DpsiLevel.unsafe: return 'Unsafe';
      case DpsiLevel.unknown: return 'Unknown';
    }
  }
}
