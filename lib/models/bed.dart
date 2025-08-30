class Bed {
  final String id;
  final String plotId;
  final int x;
  final int y;
  final double widthM;
  final double heightM;
  final DateTime createdAt;

  const Bed({
    required this.id,
    required this.plotId,
    required this.x,
    required this.y,
    required this.widthM,
    required this.heightM,
    required this.createdAt,
  });

  double get areaM2 => widthM * heightM;

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'],
      plotId: json['plot_id'],
      x: json['x'],
      y: json['y'],
      widthM: (json['width_m'] as num).toDouble(),
      heightM: (json['height_m'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plot_id': plotId,
      'x': x,
      'y': y,
      'width_m': widthM,
      'height_m': heightM,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Bed copyWith({
    String? id,
    String? plotId,
    int? x,
    int? y,
    double? widthM,
    double? heightM,
    DateTime? createdAt,
  }) {
    return Bed(
      id: id ?? this.id,
      plotId: plotId ?? this.plotId,
      x: x ?? this.x,
      y: y ?? this.y,
      widthM: widthM ?? this.widthM,
      heightM: heightM ?? this.heightM,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}