// lib/models/hive_specific_models.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'nameplate_hive.g.dart'; // Generated file for JSON serialization and Hive adapters

// --- Your Hive Models (Application-Specific Data) ---
// These models are also JsonSerializable to allow them to be converted
// to/from JSON when interacting with the API or other services.

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class Nameplate extends HiveObject {
  @HiveField(0)
  Product? product;

  @HiveField(1)
  Manufacturer? manufacturer;

  Nameplate({this.product, this.manufacturer});

  factory Nameplate.fromJson(Map<String, dynamic> json) =>
      _$NameplateFromJson(json);
  Map<String, dynamic> toJson() => _$NameplateToJson(this);
}

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class Product extends HiveObject {
  @HiveField(0)
  String? uriOfTheProduct;

  @HiveField(1)
  String? manufacturerProductType;

  @HiveField(2)
  String? orderCodeOfManufacturer;

  @HiveField(3)
  String? productArticleNumberOfManufacturer;

  @HiveField(4)  String? serialNumber;

  @HiveField(5)
  int? yearOfConstruction;

  @HiveField(6)
  DateTime? dateOfManufacture;

  @HiveField(7)
  String? countryOfOrigin;

  @HiveField(8)
  String? manufacturerProductDesignation;

  @HiveField(9)
  String? manufacturerProductRoot;

  @HiveField(10)
  String? manufacturerProductFamily;

  @HiveField(11)
  Manufacturer? manufacturer;

  @HiveField(12)
  Markings? markings;

  Product({
    this.uriOfTheProduct,
    this.manufacturerProductType,
    this.orderCodeOfManufacturer,
    this.productArticleNumberOfManufacturer,
    this.serialNumber,
    this.yearOfConstruction,
    this.dateOfManufacture,
    this.countryOfOrigin,
    this.manufacturerProductDesignation,
    this.manufacturerProductRoot,
    this.manufacturerProductFamily,
    this.manufacturer,
    this.markings,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable(explicitToJson: true)
class Manufacturer extends HiveObject {
  @HiveField(0)
  String? uniqueFacilityIdentifier;

  @HiveField(1)
  String? manufacturerName;

  Manufacturer({this.uniqueFacilityIdentifier, this.manufacturerName});

  factory Manufacturer.fromJson(Map<String, dynamic> json) =>
      _$ManufacturerFromJson(json);
  Map<String, dynamic> toJson() => _$ManufacturerToJson(this);
}

@HiveType(typeId: 3)
@JsonSerializable(explicitToJson: true)
class Markings extends HiveObject {
  @HiveField(0)
  String? markingName;

  @HiveField(1)
  String? designationOfCertificateOrApproval;

  @HiveField(2)
  DateTime? issueDate;

  @HiveField(3)
  DateTime? expiryDate;

  @HiveField(4)
  String? markingAdditionalText;

  @HiveField(5)
  String? markingFile;

  Markings({
    this.markingName,
    this.designationOfCertificateOrApproval,
    this.issueDate,
    this.expiryDate,
    this.markingAdditionalText,
    this.markingFile,
  });

  factory Markings.fromJson(Map<String, dynamic> json) =>
      _$MarkingsFromJson(json);
  Map<String, dynamic> toJson() => _$MarkingsToJson(this);
}
