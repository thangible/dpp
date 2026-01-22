// lib/models/specific_aas_models.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart'; // Import Hive-specific models for Submodel content

part 'generic_submodel.g.dart'; // Generated file for JSON serialization

// --- Main AAS Entity Models ---

@JsonSerializable(explicitToJson: true)
class Submodel {
  final String modelType;
  final String kind;
  final Reference? semanticId;
  final AdministrativeInformation? administration;
  final String id;
  final List<LangString>? description;
  final List<LangString>? displayName; // Added for display names
  final String idShort;
  final List<SubmodelElement>? submodelElements;

  Submodel({
    required this.modelType,
    required this.kind,
    this.semanticId,
    this.administration,
    required this.id,
    this.description,
    this.displayName,
    required this.idShort,
    this.submodelElements,
  });

  @override
  String toString() {
    return 'Submodel(modelType: $modelType, kind: $kind, semanticId: $semanticId, administration: $administration, id: $id, description: $description, displayName: $displayName, idShort: $idShort, submodelElements: $submodelElements)';
  }

  factory Submodel.fromJson(Map<String, dynamic> json) =>
      _$SubmodelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmodelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AssetAdministrationShell {
  final String id;
  final String idShort;
  final String? modelType;
  final AssetInformation? assetInformation;
  final List<Reference>?
  submodels; // Changed from generic content to specific submodel references

  AssetAdministrationShell({
    required this.id,
    required this.idShort,
    this.modelType,
    this.assetInformation,
    this.submodels,
  });

  factory AssetAdministrationShell.fromJson(Map<String, dynamic> json) =>
      _$AssetAdministrationShellFromJson(json);
  Map<String, dynamic> toJson() => _$AssetAdministrationShellToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ConceptDescription {
  final String modelType;
  final List<EmbeddedDataSpecification>? embeddedDataSpecifications;
  final String id;
  final List<LangString>? description;
  final String idShort;
  final Reference? isCaseOf;

  ConceptDescription({
    required this.modelType,
    this.embeddedDataSpecifications,
    required this.id,
    this.description,
    required this.idShort,
    this.isCaseOf,
  });

  factory ConceptDescription.fromJson(Map<String, dynamic> json) =>
      _$ConceptDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptDescriptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AssetInformation {
  final String globalAssetId;
  final String assetKind;
  final String? assetType; // Added assetType field

  AssetInformation({
    required this.globalAssetId,
    required this.assetKind,
    this.assetType,
  });

  factory AssetInformation.fromJson(Map<String, dynamic> json) =>
      _$AssetInformationFromJson(json);
  Map<String, dynamic> toJson() => _$AssetInformationToJson(this);
}

// Add a wrapper class for the complete AAS response
@JsonSerializable(explicitToJson: true)
class AasResponse {
  final List<AssetAdministrationShell>? assetAdministrationShells;
  final List<Submodel>? submodels;
  final List<ConceptDescription>? conceptDescriptions;

  AasResponse({
    this.assetAdministrationShells,
    this.submodels,
    this.conceptDescriptions,
  });

  factory AasResponse.fromJson(Map<String, dynamic> json) =>
      _$AasResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AasResponseToJson(this);
}
