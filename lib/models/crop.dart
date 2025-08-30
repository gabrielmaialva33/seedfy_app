class Crop {
  final String id;
  final String namePt;
  final String nameEn;
  final String imageUrl;
  final double rowSpacingM;
  final double plantSpacingM;
  final int cycleDays;
  final double? yieldPerM2;

  const Crop({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.imageUrl,
    required this.rowSpacingM,
    required this.plantSpacingM,
    required this.cycleDays,
    this.yieldPerM2,
  });

  String getName(String locale) {
    return locale.startsWith('pt') ? namePt : nameEn;
  }

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      namePt: json['name_pt'],
      nameEn: json['name_en'],
      imageUrl: json['image_url'],
      rowSpacingM: (json['row_spacing_m'] as num).toDouble(),
      plantSpacingM: (json['plant_spacing_m'] as num).toDouble(),
      cycleDays: json['cycle_days'],
      yieldPerM2: json['yield_per_m2']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_pt': namePt,
      'name_en': nameEn,
      'image_url': imageUrl,
      'row_spacing_m': rowSpacingM,
      'plant_spacing_m': plantSpacingM,
      'cycle_days': cycleDays,
      'yield_per_m2': yieldPerM2,
    };
  }
}