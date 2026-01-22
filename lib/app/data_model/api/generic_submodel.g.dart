// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_submodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Submodel _$SubmodelFromJson(Map<String, dynamic> json) => Submodel(
      modelType: json['modelType'] as String,
      kind: json['kind'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      administration: json['administration'] == null
          ? null
          : AdministrativeInformation.fromJson(
              json['administration'] as Map<String, dynamic>),
      id: json['id'] as String,
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      displayName: (json['displayName'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      idShort: json['idShort'] as String,
      submodelElements: (json['submodelElements'] as List<dynamic>?)
          ?.map((e) => SubmodelElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmodelToJson(Submodel instance) => <String, dynamic>{
      'modelType': instance.modelType,
      'kind': instance.kind,
      'semanticId': instance.semanticId?.toJson(),
      'administration': instance.administration?.toJson(),
      'id': instance.id,
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'displayName': instance.displayName?.map((e) => e.toJson()).toList(),
      'idShort': instance.idShort,
      'submodelElements':
          instance.submodelElements?.map((e) => e.toJson()).toList(),
    };

AssetAdministrationShell _$AssetAdministrationShellFromJson(
        Map<String, dynamic> json) =>
    AssetAdministrationShell(
      id: json['id'] as String,
      idShort: json['idShort'] as String,
      modelType: json['modelType'] as String?,
      assetInformation: json['assetInformation'] == null
          ? null
          : AssetInformation.fromJson(
              json['assetInformation'] as Map<String, dynamic>),
      submodels: (json['submodels'] as List<dynamic>?)
          ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetAdministrationShellToJson(
        AssetAdministrationShell instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idShort': instance.idShort,
      'modelType': instance.modelType,
      'assetInformation': instance.assetInformation?.toJson(),
      'submodels': instance.submodels?.map((e) => e.toJson()).toList(),
    };

ConceptDescription _$ConceptDescriptionFromJson(Map<String, dynamic> json) =>
    ConceptDescription(
      modelType: json['modelType'] as String,
      embeddedDataSpecifications:
          (json['embeddedDataSpecifications'] as List<dynamic>?)
              ?.map((e) =>
                  EmbeddedDataSpecification.fromJson(e as Map<String, dynamic>))
              .toList(),
      id: json['id'] as String,
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      idShort: json['idShort'] as String,
      isCaseOf: json['isCaseOf'] == null
          ? null
          : Reference.fromJson(json['isCaseOf'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConceptDescriptionToJson(ConceptDescription instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'embeddedDataSpecifications':
          instance.embeddedDataSpecifications?.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'idShort': instance.idShort,
      'isCaseOf': instance.isCaseOf?.toJson(),
    };

AssetInformation _$AssetInformationFromJson(Map<String, dynamic> json) =>
    AssetInformation(
      globalAssetId: json['globalAssetId'] as String,
      assetKind: json['assetKind'] as String,
      assetType: json['assetType'] as String?,
    );

Map<String, dynamic> _$AssetInformationToJson(AssetInformation instance) =>
    <String, dynamic>{
      'globalAssetId': instance.globalAssetId,
      'assetKind': instance.assetKind,
      'assetType': instance.assetType,
    };

AasResponse _$AasResponseFromJson(Map<String, dynamic> json) => AasResponse(
      assetAdministrationShells:
          (json['assetAdministrationShells'] as List<dynamic>?)
              ?.map((e) =>
                  AssetAdministrationShell.fromJson(e as Map<String, dynamic>))
              .toList(),
      submodels: (json['submodels'] as List<dynamic>?)
          ?.map((e) => Submodel.fromJson(e as Map<String, dynamic>))
          .toList(),
      conceptDescriptions: (json['conceptDescriptions'] as List<dynamic>?)
          ?.map((e) => ConceptDescription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AasResponseToJson(AasResponse instance) =>
    <String, dynamic>{
      'assetAdministrationShells':
          instance.assetAdministrationShells?.map((e) => e.toJson()).toList(),
      'submodels': instance.submodels?.map((e) => e.toJson()).toList(),
      'conceptDescriptions':
          instance.conceptDescriptions?.map((e) => e.toJson()).toList(),
    };
