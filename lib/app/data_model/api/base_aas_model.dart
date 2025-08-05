import 'package:json_annotation/json_annotation.dart';

part 'base_aas_model.g.dart'; // Generated file for JSON serialization

// --- 1. Generic Top-level API Response Wrapper ---
@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class PagingResponse<T> {
  @JsonKey(name: 'paging_metadata')
  final Map<String, dynamic>? pagingMetadata; //TODO: change dynamic type to a specific type
  final List<T> result;

  PagingResponse({this.pagingMetadata, required this.result});

  factory PagingResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PagingResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PagingResponseToJson(this, toJsonT);
}

// --- 2. AAS Meta-Model Core Data Models ---

@JsonSerializable(explicitToJson: true)
class Reference {
  final String? type;
  final List<Key>? keys;

  Reference({this.type, this.keys});

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}

@JsonSerializable()
class Key {
  final String? type;
  final String? value;

  Key({this.type, this.value});

  factory Key.fromJson(Map<String, dynamic> json) => _$KeyFromJson(json);
  Map<String, dynamic> toJson() => _$KeyToJson(this);
}

@JsonSerializable()
class LangString {
  final String? language;
  final String? text;

  LangString({this.language, this.text});

  factory LangString.fromJson(Map<String, dynamic> json) =>
      _$LangStringFromJson(json);
  Map<String, dynamic> toJson() => _$LangStringToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AdministrativeInformation {
  final String? version;
  final String? revision;
  final String? templateId;

  AdministrativeInformation({this.version, this.revision, this.templateId});

  factory AdministrativeInformation.fromJson(Map<String, dynamic> json) =>
      _$AdministrativeInformationFromJson(json);
  Map<String, dynamic> toJson() => _$AdministrativeInformationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Qualifier {
  final Reference semanticId;
  final String kind;
  final String type;
  final String value;
  final String valueType;

  Qualifier({
    required this.semanticId,
    required this.kind,
    required this.type,
    required this.value,
    required this.valueType,
  });

  factory Qualifier.fromJson(Map<String, dynamic> json) =>
      _$QualifierFromJson(json);
  Map<String, dynamic> toJson() => _$QualifierToJson(this);
}

// --- 3. Submodel Element Base Class and Specific Types (Polymorphic) ---
// Note: The fromJson factory in SubmodelElement handles polymorphic deserialization.
// Ensure all specific SubmodelElement types are defined here or imported.
@JsonSerializable(explicitToJson: true)
class SubmodelElement {
  final String? modelType;
  final String? idShort;
  final Reference? semanticId;
  final List<Reference>? supplementalSemanticIds;
  final List<LangString>? description;
  final List<Qualifier>? qualifiers;

  SubmodelElement({
    this.modelType,
    this.idShort,
    this.semanticId,
    this.supplementalSemanticIds,
    this.description,
    this.qualifiers,
  });

  // This factory is crucial for polymorphic deserialization.
  factory SubmodelElement.fromJson(Map<String, dynamic> json) {
    final modelType = json['modelType'] as String?;
    if (modelType == null) {
      return _$SubmodelElementFromJson(json);
    }

    switch (modelType) {
      case 'Property':
        return Property.fromJson(json);
      case 'File':
        return FileSubmodelElement.fromJson(json);
      case 'MultiLanguageProperty':
        return MultiLanguageProperty.fromJson(json);
      case 'SubmodelElementCollection':
        return SubmodelElementCollection.fromJson(json);
      case 'SubmodelElementList':
        return SubmodelElementList.fromJson(json);
      default:
        return _$SubmodelElementFromJson(json);
    }
  }
  Map<String, dynamic> toJson() => _$SubmodelElementToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Property extends SubmodelElement {
  final dynamic value; // Can be String, int, double, bool, etc.
  final String? valueType;

  Property({
    super.modelType,
    super.idShort,
    super.semanticId,
    super.supplementalSemanticIds,
    super.description,
    super.qualifiers,
    this.value,
    required this.valueType,
  });

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FileSubmodelElement extends SubmodelElement {
  final String? contentType;
  final String? value; // The path/URL to the file

  FileSubmodelElement({
    super.modelType,
    super.idShort,
    super.semanticId,
    super.supplementalSemanticIds,
    super.description,
    super.qualifiers,
    this.contentType,
    this.value,
  });

  factory FileSubmodelElement.fromJson(Map<String, dynamic> json) =>
      _$FileSubmodelElementFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FileSubmodelElementToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MultiLanguageProperty extends SubmodelElement {
  final List<LangString> value;
  final Reference? valueId;

  MultiLanguageProperty({
    required super.modelType,
    required super.idShort,
    super.semanticId,
    super.supplementalSemanticIds,
    super.description,
    super.qualifiers,
    required this.value,
    this.valueId,
  });

  factory MultiLanguageProperty.fromJson(Map<String, dynamic> json) =>
      _$MultiLanguagePropertyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MultiLanguagePropertyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubmodelElementCollection extends SubmodelElement {
  final List<SubmodelElement>? value; // Nested submodel elements

  SubmodelElementCollection({
    super.modelType,
    super.idShort,
    super.semanticId,
    super.supplementalSemanticIds,
    super.description,
    super.qualifiers,
    this.value,
  });

  factory SubmodelElementCollection.fromJson(Map<String, dynamic> json) =>
      _$SubmodelElementCollectionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SubmodelElementCollectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubmodelElementList extends SubmodelElement {
  final bool? orderRelevant;
  final String? typeValueListElement;
  final List<SubmodelElement>? value; // Nested submodel elements

  SubmodelElementList({
    super.modelType, // Remove 'required'
    super.idShort, // Remove 'required'
    super.semanticId,
    super.supplementalSemanticIds,
    super.description,
    super.qualifiers,
    this.orderRelevant,
    this.typeValueListElement,
    this.value,
  });

  factory SubmodelElementList.fromJson(Map<String, dynamic> json) =>
      _$SubmodelElementListFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SubmodelElementListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EmbeddedDataSpecification {
  final Reference dataSpecification;
  final DataSpecificationContent dataSpecificationContent;

  EmbeddedDataSpecification({
    required this.dataSpecification,
    required this.dataSpecificationContent,
  });

  factory EmbeddedDataSpecification.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedDataSpecificationFromJson(json);
  Map<String, dynamic> toJson() => _$EmbeddedDataSpecificationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DataSpecificationContent {
  final String modelType;
  final List<LangString>? definition;
  final List<LangString>? preferredName;
  final String? dataType; // Added for IEC61360
  final List<LangString>? shortName; // Added for IEC61360

  DataSpecificationContent({
    required this.modelType,
    this.definition,
    this.preferredName,
    this.dataType,
    this.shortName,
  });

  factory DataSpecificationContent.fromJson(Map<String, dynamic> json) =>
      _$DataSpecificationContentFromJson(json);
  Map<String, dynamic> toJson() => _$DataSpecificationContentToJson(this);
}

@JsonSerializable()
class UploadResponse {
  final String message; // Example field
  // Add other fields as per your API response for upload
  UploadResponse({required this.message});

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}
