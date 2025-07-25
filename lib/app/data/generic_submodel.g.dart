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
      'idShort': instance.idShort,
      'submodelElements':
          instance.submodelElements?.map((e) => e.toJson()).toList(),
    };

AssetAdministrationShell _$AssetAdministrationShellFromJson(
        Map<String, dynamic> json) =>
    AssetAdministrationShell(
      id: json['id'] as String,
      content: json['content'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AssetAdministrationShellToJson(
        AssetAdministrationShell instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
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
    );

Map<String, dynamic> _$AssetInformationToJson(AssetInformation instance) =>
    <String, dynamic>{
      'globalAssetId': instance.globalAssetId,
      'assetKind': instance.assetKind,
    };

OperationRequest _$OperationRequestFromJson(Map<String, dynamic> json) =>
    OperationRequest(
      inputArguments: json['inputArguments'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$OperationRequestToJson(OperationRequest instance) =>
    <String, dynamic>{
      'inputArguments': instance.inputArguments,
    };

OperationResponse _$OperationResponseFromJson(Map<String, dynamic> json) =>
    OperationResponse(
      outputArguments: json['outputArguments'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$OperationResponseToJson(OperationResponse instance) =>
    <String, dynamic>{
      'outputArguments': instance.outputArguments,
    };
