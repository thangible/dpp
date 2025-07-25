// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_aas_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagingResponse<T> _$PagingResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PagingResponse<T>(
      pagingMetadata: json['paging_metadata'] as Map<String, dynamic>?,
      result: (json['result'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$PagingResponseToJson<T>(
  PagingResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'paging_metadata': instance.pagingMetadata,
      'result': instance.result.map(toJsonT).toList(),
    };

Reference _$ReferenceFromJson(Map<String, dynamic> json) => Reference(
      type: json['type'] as String,
      keys: (json['keys'] as List<dynamic>)
          .map((e) => Key.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReferenceToJson(Reference instance) => <String, dynamic>{
      'type': instance.type,
      'keys': instance.keys.map((e) => e.toJson()).toList(),
    };

Key _$KeyFromJson(Map<String, dynamic> json) => Key(
      type: json['type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$KeyToJson(Key instance) => <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
    };

LangString _$LangStringFromJson(Map<String, dynamic> json) => LangString(
      language: json['language'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$LangStringToJson(LangString instance) =>
    <String, dynamic>{
      'language': instance.language,
      'text': instance.text,
    };

AdministrativeInformation _$AdministrativeInformationFromJson(
        Map<String, dynamic> json) =>
    AdministrativeInformation(
      version: json['version'] as String?,
      revision: json['revision'] as String?,
      templateId: json['templateId'] as String?,
    );

Map<String, dynamic> _$AdministrativeInformationToJson(
        AdministrativeInformation instance) =>
    <String, dynamic>{
      'version': instance.version,
      'revision': instance.revision,
      'templateId': instance.templateId,
    };

Qualifier _$QualifierFromJson(Map<String, dynamic> json) => Qualifier(
      semanticId:
          Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      kind: json['kind'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      valueType: json['valueType'] as String,
    );

Map<String, dynamic> _$QualifierToJson(Qualifier instance) => <String, dynamic>{
      'semanticId': instance.semanticId.toJson(),
      'kind': instance.kind,
      'type': instance.type,
      'value': instance.value,
      'valueType': instance.valueType,
    };

SubmodelElement _$SubmodelElementFromJson(Map<String, dynamic> json) =>
    SubmodelElement(
      modelType: json['modelType'] as String,
      idShort: json['idShort'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      supplementalSemanticIds:
          (json['supplementalSemanticIds'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifiers: (json['qualifiers'] as List<dynamic>?)
          ?.map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmodelElementToJson(SubmodelElement instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'idShort': instance.idShort,
      'semanticId': instance.semanticId?.toJson(),
      'supplementalSemanticIds':
          instance.supplementalSemanticIds?.map((e) => e.toJson()).toList(),
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'qualifiers': instance.qualifiers?.map((e) => e.toJson()).toList(),
    };

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      modelType: json['modelType'] as String,
      idShort: json['idShort'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      supplementalSemanticIds:
          (json['supplementalSemanticIds'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifiers: (json['qualifiers'] as List<dynamic>?)
          ?.map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      value: json['value'],
      valueType: json['valueType'] as String,
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'modelType': instance.modelType,
      'idShort': instance.idShort,
      'semanticId': instance.semanticId?.toJson(),
      'supplementalSemanticIds':
          instance.supplementalSemanticIds?.map((e) => e.toJson()).toList(),
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'qualifiers': instance.qualifiers?.map((e) => e.toJson()).toList(),
      'value': instance.value,
      'valueType': instance.valueType,
    };

FileSubmodelElement _$FileSubmodelElementFromJson(Map<String, dynamic> json) =>
    FileSubmodelElement(
      modelType: json['modelType'] as String,
      idShort: json['idShort'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      supplementalSemanticIds:
          (json['supplementalSemanticIds'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifiers: (json['qualifiers'] as List<dynamic>?)
          ?.map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      contentType: json['contentType'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$FileSubmodelElementToJson(
        FileSubmodelElement instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'idShort': instance.idShort,
      'semanticId': instance.semanticId?.toJson(),
      'supplementalSemanticIds':
          instance.supplementalSemanticIds?.map((e) => e.toJson()).toList(),
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'qualifiers': instance.qualifiers?.map((e) => e.toJson()).toList(),
      'contentType': instance.contentType,
      'value': instance.value,
    };

MultiLanguageProperty _$MultiLanguagePropertyFromJson(
        Map<String, dynamic> json) =>
    MultiLanguageProperty(
      modelType: json['modelType'] as String,
      idShort: json['idShort'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      supplementalSemanticIds:
          (json['supplementalSemanticIds'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifiers: (json['qualifiers'] as List<dynamic>?)
          ?.map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      value: (json['value'] as List<dynamic>)
          .map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      valueId: json['valueId'] == null
          ? null
          : Reference.fromJson(json['valueId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultiLanguagePropertyToJson(
        MultiLanguageProperty instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'idShort': instance.idShort,
      'semanticId': instance.semanticId?.toJson(),
      'supplementalSemanticIds':
          instance.supplementalSemanticIds?.map((e) => e.toJson()).toList(),
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'qualifiers': instance.qualifiers?.map((e) => e.toJson()).toList(),
      'value': instance.value.map((e) => e.toJson()).toList(),
      'valueId': instance.valueId?.toJson(),
    };

SubmodelElementCollection _$SubmodelElementCollectionFromJson(
        Map<String, dynamic> json) =>
    SubmodelElementCollection(
      modelType: json['modelType'] as String,
      idShort: json['idShort'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      supplementalSemanticIds:
          (json['supplementalSemanticIds'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifiers: (json['qualifiers'] as List<dynamic>?)
          ?.map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      value: (json['value'] as List<dynamic>?)
          ?.map((e) => SubmodelElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmodelElementCollectionToJson(
        SubmodelElementCollection instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'idShort': instance.idShort,
      'semanticId': instance.semanticId?.toJson(),
      'supplementalSemanticIds':
          instance.supplementalSemanticIds?.map((e) => e.toJson()).toList(),
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'qualifiers': instance.qualifiers?.map((e) => e.toJson()).toList(),
      'value': instance.value?.map((e) => e.toJson()).toList(),
    };

SubmodelElementList _$SubmodelElementListFromJson(Map<String, dynamic> json) =>
    SubmodelElementList(
      modelType: json['modelType'] as String,
      idShort: json['idShort'] as String,
      semanticId: json['semanticId'] == null
          ? null
          : Reference.fromJson(json['semanticId'] as Map<String, dynamic>),
      supplementalSemanticIds:
          (json['supplementalSemanticIds'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifiers: (json['qualifiers'] as List<dynamic>?)
          ?.map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderRelevant: json['orderRelevant'] as bool?,
      typeValueListElement: json['typeValueListElement'] as String?,
      value: (json['value'] as List<dynamic>?)
          ?.map((e) => SubmodelElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmodelElementListToJson(
        SubmodelElementList instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'idShort': instance.idShort,
      'semanticId': instance.semanticId?.toJson(),
      'supplementalSemanticIds':
          instance.supplementalSemanticIds?.map((e) => e.toJson()).toList(),
      'description': instance.description?.map((e) => e.toJson()).toList(),
      'qualifiers': instance.qualifiers?.map((e) => e.toJson()).toList(),
      'orderRelevant': instance.orderRelevant,
      'typeValueListElement': instance.typeValueListElement,
      'value': instance.value?.map((e) => e.toJson()).toList(),
    };

EmbeddedDataSpecification _$EmbeddedDataSpecificationFromJson(
        Map<String, dynamic> json) =>
    EmbeddedDataSpecification(
      dataSpecification:
          Reference.fromJson(json['dataSpecification'] as Map<String, dynamic>),
      dataSpecificationContent: DataSpecificationContent.fromJson(
          json['dataSpecificationContent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmbeddedDataSpecificationToJson(
        EmbeddedDataSpecification instance) =>
    <String, dynamic>{
      'dataSpecification': instance.dataSpecification.toJson(),
      'dataSpecificationContent': instance.dataSpecificationContent.toJson(),
    };

DataSpecificationContent _$DataSpecificationContentFromJson(
        Map<String, dynamic> json) =>
    DataSpecificationContent(
      modelType: json['modelType'] as String,
      definition: (json['definition'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferredName: (json['preferredName'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataType: json['dataType'] as String?,
      shortName: (json['shortName'] as List<dynamic>?)
          ?.map((e) => LangString.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataSpecificationContentToJson(
        DataSpecificationContent instance) =>
    <String, dynamic>{
      'modelType': instance.modelType,
      'definition': instance.definition?.map((e) => e.toJson()).toList(),
      'preferredName': instance.preferredName?.map((e) => e.toJson()).toList(),
      'dataType': instance.dataType,
      'shortName': instance.shortName?.map((e) => e.toJson()).toList(),
    };

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
