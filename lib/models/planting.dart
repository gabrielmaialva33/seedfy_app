enum PlantingStatus {
  healthy,
  warning,
  critical,
}

class Planting {
  final String id;
  final String bedId;
  final String cropId;
  final int? customCycleDays;
  final double? customRowSpacingM;
  final double? customPlantSpacingM;
  final DateTime sowingDate;
  final DateTime harvestEstimate;
  final int quantity;
  final String? intercropOf;
  final String? notes;

  const Planting({
    required this.id,
    required this.bedId,
    required this.cropId,
    this.customCycleDays,
    this.customRowSpacingM,
    this.customPlantSpacingM,
    required this.sowingDate,
    required this.harvestEstimate,
    required this.quantity,
    this.intercropOf,
    this.notes,
  });

  PlantingStatus getStatus() {
    final now = DateTime.now();
    final totalDays = harvestEstimate.difference(sowingDate).inDays;
    final daysElapsed = now.difference(sowingDate).inDays;
    final progressPercent = daysElapsed / totalDays;

    if (progressPercent < 0.5) {
      return PlantingStatus.healthy;
    } else if (progressPercent < 0.8) {
      return PlantingStatus.warning;
    } else {
      return PlantingStatus.critical;
    }
  }

  int get daysUntilHarvest {
    final now = DateTime.now();
    return harvestEstimate.difference(now).inDays;
  }

  factory Planting.fromJson(Map<String, dynamic> json) {
    return Planting(
      id: json['id'],
      bedId: json['bed_id'],
      cropId: json['crop_id'],
      customCycleDays: json['custom_cycle_days'],
      customRowSpacingM: json['custom_row_spacing_m']?.toDouble(),
      customPlantSpacingM: json['custom_plant_spacing_m']?.toDouble(),
      sowingDate: DateTime.parse(json['sowing_date']),
      harvestEstimate: DateTime.parse(json['harvest_estimate']),
      quantity: json['quantity'],
      intercropOf: json['intercrop_of'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bed_id': bedId,
      'crop_id': cropId,
      'custom_cycle_days': customCycleDays,
      'custom_row_spacing_m': customRowSpacingM,
      'custom_plant_spacing_m': customPlantSpacingM,
      'sowing_date': sowingDate.toIso8601String().split('T')[0],
      'harvest_estimate': harvestEstimate.toIso8601String().split('T')[0],
      'quantity': quantity,
      'intercrop_of': intercropOf,
      'notes': notes,
    };
  }
}