class Plot {
  final String id;
  final String farmId;
  final String label;
  final double lengthM;
  final double widthM;
  final double pathGapM;
  final DateTime createdAt;

  const Plot({
    required this.id,
    required this.farmId,
    required this.label,
    required this.lengthM,
    required this.widthM,
    required this.pathGapM,
    required this.createdAt,
  });

  double get areaM2 => lengthM * widthM;

  factory Plot.fromJson(Map<String, dynamic> json) {
    return Plot(
      id: json['id'],
      farmId: json['farm_id'],
      label: json['label'],
      lengthM: (json['length_m'] as num).toDouble(),
      widthM: (json['width_m'] as num).toDouble(),
      pathGapM: (json['path_gap_m'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'label': label,
      'length_m': lengthM,
      'width_m': widthM,
      'path_gap_m': pathGapM,
      'created_at': createdAt.toIso8601String(),
    };
  }
}