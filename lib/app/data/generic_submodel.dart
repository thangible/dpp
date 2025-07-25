// lib/models/specific_aas_models.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:dpp/app/data/base_aas_model.dart'; // Import Hive-specific models for Submodel content

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
  final String idShort;
  final List<SubmodelElement>? submodelElements;

  Submodel({
    required this.modelType,
    required this.kind,
    this.semanticId,
    this.administration,
    required this.id,
    this.description,
    required this.idShort,
    this.submodelElements,
  });

  factory Submodel.fromJson(Map<String, dynamic> json) =>
      _$SubmodelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmodelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AssetAdministrationShell {
  final String id;
  final Map<String, dynamic> content; // Placeholder for AAS content

  AssetAdministrationShell({required this.id, required this.content});

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
  AssetInformation({required this.globalAssetId, required this.assetKind});

  factory AssetInformation.fromJson(Map<String, dynamic> json) =>
      _$AssetInformationFromJson(json);
  Map<String, dynamic> toJson() => _$AssetInformationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OperationRequest {
  final Map<String, dynamic> inputArguments;
  OperationRequest({required this.inputArguments});

  factory OperationRequest.fromJson(Map<String, dynamic> json) =>
      _$OperationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OperationRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OperationResponse {
  final Map<String, dynamic> outputArguments;
  OperationResponse({required this.outputArguments});

  factory OperationResponse.fromJson(Map<String, dynamic> json) =>
      _$OperationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OperationResponseToJson(this);
}
