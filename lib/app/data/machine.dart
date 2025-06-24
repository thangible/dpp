class Machine {
  final int id;
  final double energyUsed;
  final double co2Emissions;
  final DateTime lastUpdated;
  final String type;
  final String material;
  final String manufacturer;
  final double virginMaterial;
  final double recycledMaterial;
  final String imagePath;

  Machine({
    required this.id,
    required this.energyUsed,
    required this.co2Emissions,
    required this.lastUpdated,
    required this.type,
    required this.material,
    required this.manufacturer,
    required this.virginMaterial,
    required this.recycledMaterial,
    required this.imagePath,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'] as int,
      energyUsed: (json['energyUsed'] as num).toDouble(),
      co2Emissions: (json['co2Emissions'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      type: json['type'] as String,
      material: json['material'] as String,
      manufacturer: json['manufacturer'] as String,
      virginMaterial: (json['virginMaterial'] as num).toDouble(),
      recycledMaterial: (json['recycledMaterial'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'energyUsed': energyUsed,
      'co2Emissions': co2Emissions,
      'lastUpdated': lastUpdated.toIso8601String(),
      'type': type,
      'material': material,
      'manufacturer': manufacturer,
      'virginMaterial': virginMaterial,
      'recycledMaterial': recycledMaterial,
      'imagePath': imagePath,
    };
  }
}