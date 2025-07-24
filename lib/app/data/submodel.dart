import 'dart:convert';

// --- Model Classes ---

/// Represents a Submodel in the Asset Administration Shell (AAS) structure.
/// A Submodel groups a set of SubmodelElements under a common semantic ID.
class Submodel {
  /// The model type of this Submodel (e.g., 'Submodel').
  final String modelType;

  /// The kind of the Submodel (e.g., 'Instance', 'Template').
  final String kind;

  /// The semantic ID of the Submodel, providing a unique identification
  /// for its meaning and purpose.
  final SemanticId semanticId;

  /// Administrative information about the Submodel, such as revision and version.
  final Administration administration;

  /// The globally unique ID of the Submodel.
  final String id;

  /// A list of human-readable descriptions for the Submodel in different languages.
  final List<Description> description;

  /// A short, non-unique human-readable identifier.
  final String idShort;

  /// A list of Submodel elements contained within this Submodel.
  /// These can be properties, collections, etc.
  final List<SubmodelElement> submodelElements;

  /// Constructor for the Submodel class.
  Submodel({
    required this.modelType,
    required this.kind,
    required this.semanticId,
    required this.administration,
    required this.id,
    required this.description,
    required this.idShort,
    required this.submodelElements,
  });

  /// Factory constructor to create a [Submodel] instance from a JSON map.
  factory Submodel.fromJson(Map<String, dynamic> json) {
    return Submodel(
      modelType: json['modelType'] as String,
      kind: json['kind'] as String,
      semanticId: SemanticId.fromJson(
        json['semanticId'] as Map<String, dynamic>,
      ),
      administration: Administration.fromJson(
        json['administration'] as Map<String, dynamic>,
      ),
      id: json['id'] as String,
      description:
          (json['description'] as List<dynamic>)
              .map((e) => Description.fromJson(e as Map<String, dynamic>))
              .toList(),
      idShort: json['idShort'] as String,
      submodelElements:
          (json['submodelElements'] as List<dynamic>)
              .map((e) => SubmodelElement.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

/// Represents a Semantic ID, which is a collection of [Key]s that uniquely
/// identify the semantic meaning of an element.
class SemanticId {
  /// A list of keys that constitute the semantic ID.
  final List<Key> keys;

  /// The type of the semantic ID (e.g., 'ExternalReference').
  final String type;

  /// Constructor for the SemanticId class.
  SemanticId({required this.keys, required this.type});

  /// Factory constructor to create a [SemanticId] instance from a JSON map.
  factory SemanticId.fromJson(Map<String, dynamic> json) {
    return SemanticId(
      keys:
          (json['keys'] as List<dynamic>)
              .map((e) => Key.fromJson(e as Map<String, dynamic>))
              .toList(),
      type: json['type'] as String,
    );
  }
}

/// Represents a single Key within a Semantic ID or Value ID.
/// It defines the type and value of a reference.
class Key {
  /// The type of the key (e.g., 'GlobalReference', 'ConceptDescription').
  final String type;

  /// The value of the key, typically an ID or a path.
  final String value;

  /// Constructor for the Key class.
  Key({required this.type, required this.value});

  /// Factory constructor to create a [Key] instance from a JSON map.
  factory Key.fromJson(Map<String, dynamic> json) {
    return Key(type: json['type'] as String, value: json['value'] as String);
  }
}

/// Represents administrative information for an AAS element.
class Administration {
  /// The revision of the element.
  final String revision;

  /// The template ID used for the element.
  final String templateId;

  /// The version of the element.
  final String version;

  /// Constructor for the Administration class.
  Administration({
    required this.revision,
    required this.templateId,
    required this.version,
  });

  /// Factory constructor to create an [Administration] instance from a JSON map.
  factory Administration.fromJson(Map<String, dynamic> json) {
    return Administration(
      revision: json['revision'] as String,
      templateId: json['templateId'] as String,
      version: json['version'] as String,
    );
  }
}

/// Represents a human-readable description in a specific language.
class Description {
  /// The language of the description (e.g., 'en', 'de').
  final String language;

  /// The text of the description.
  final String text;

  /// Constructor for the Description class.
  Description({required this.language, required this.text});

  /// Factory constructor to create a [Description] instance from a JSON map.
  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      language: json['language'] as String,
      text: json['text'] as String,
    );
  }
}

/// Represents a single element within a Submodel.
/// Its `value` can be dynamic based on its `modelType`.
class SubmodelElement {
  /// The model type of the Submodel element (e.g., 'Property', 'MultiLanguageProperty', 'SubmodelElementCollection').
  final String modelType;

  /// The semantic ID of the Submodel element.
  final SemanticId semanticId;

  /// Optional list of supplemental semantic IDs.
  final List<SemanticId>? supplementalSemanticIds;

  /// The actual value of the Submodel element. This can vary in type:
  /// - String for 'Property'
  /// - List<MultiLanguageValue> for 'MultiLanguageProperty'
  /// - List<SubmodelElement> for 'SubmodelElementCollection'
  final dynamic value;

  /// Optional type of the value (e.g., 'string', 'int', 'boolean').
  final String? valueType;

  /// Optional list of qualifiers that provide additional meaning or context.
  final List<Qualifier>? qualifiers;

  /// A short, non-unique human-readable identifier for the element.
  final String idShort;

  /// Optional list of human-readable descriptions for the element.
  final List<Description>? description;

  /// Optional Value ID, which is a reference to the actual value.
  final ValueId? valueId;

  /// Constructor for the SubmodelElement class.
  SubmodelElement({
    required this.modelType,
    required this.semanticId,
    this.supplementalSemanticIds,
    this.value,
    this.valueType,
    this.qualifiers,
    required this.idShort,
    this.description,
    this.valueId,
  });

  /// Factory constructor to create a [SubmodelElement] instance from a JSON map.
  factory SubmodelElement.fromJson(Map<String, dynamic> json) {
    // Safely parse optional lists
    List<SemanticId>? supplementalSemanticIds;
    if (json.containsKey('supplementalSemanticIds')) {
      supplementalSemanticIds =
          (json['supplementalSemanticIds'] as List<dynamic>)
              .map((e) => SemanticId.fromJson(e as Map<String, dynamic>))
              .toList();
    }

    List<Qualifier>? qualifiers;
    if (json.containsKey('qualifiers')) {
      qualifiers =
          (json['qualifiers'] as List<dynamic>)
              .map((e) => Qualifier.fromJson(e as Map<String, dynamic>))
              .toList();
    }

    List<Description>? description;
    if (json.containsKey('description')) {
      description =
          (json['description'] as List<dynamic>)
              .map((e) => Description.fromJson(e as Map<String, dynamic>))
              .toList();
    }

    // Handle dynamic 'value' based on 'modelType'
    dynamic elementValue;
    if (json.containsKey('value')) {
      if (json['modelType'] == 'MultiLanguageProperty') {
        elementValue =
            (json['value'] as List<dynamic>)
                .map(
                  (e) => MultiLanguageValue.fromJson(e as Map<String, dynamic>),
                )
                .toList();
      } else if (json['modelType'] == 'SubmodelElementCollection') {
        elementValue =
            (json['value'] as List<dynamic>)
                .map((e) => SubmodelElement.fromJson(e as Map<String, dynamic>))
                .toList();
      } else {
        // Default case for 'Property' or other simple types
        elementValue = json['value'];
      }
    }

    // Safely parse optional ValueId
    ValueId? valueId;
    if (json.containsKey('valueId')) {
      valueId = ValueId.fromJson(json['valueId'] as Map<String, dynamic>);
    }

    return SubmodelElement(
      modelType: json['modelType'] as String,
      semanticId: SemanticId.fromJson(
        json['semanticId'] as Map<String, dynamic>,
      ),
      supplementalSemanticIds: supplementalSemanticIds,
      value: elementValue,
      valueType: json['valueType'] as String?,
      qualifiers: qualifiers,
      idShort: json['idShort'] as String,
      description: description,
      valueId: valueId,
    );
  }
}

/// Represents a Qualifier, which provides additional semantic context to an element.
class Qualifier {
  /// The semantic ID of the qualifier.
  final SemanticId semanticId;

  /// The kind of the qualifier (e.g., 'Template', 'Instance').
  final String kind;

  /// The type of the qualifier (e.g., 'DataType').
  final String type;

  /// The value of the qualifier.
  final String value;

  /// The data type of the qualifier's value.
  final String valueType;

  /// Constructor for the Qualifier class.
  Qualifier({
    required this.semanticId,
    required this.kind,
    required this.type,
    required this.value,
    required this.valueType,
  });

  /// Factory constructor to create a [Qualifier] instance from a JSON map.
  factory Qualifier.fromJson(Map<String, dynamic> json) {
    return Qualifier(
      semanticId: SemanticId.fromJson(
        json['semanticId'] as Map<String, dynamic>,
      ),
      kind: json['kind'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      valueType: json['valueType'] as String,
    );
  }
}

/// Represents a value that can be provided in multiple languages.
class MultiLanguageValue {
  /// The language of the text (e.g., 'en', 'de').
  final String language;

  /// The text in the specified language.
  final String text;

  /// Constructor for the MultiLanguageValue class.
  MultiLanguageValue({required this.language, required this.text});

  /// Factory constructor to create a [MultiLanguageValue] instance from a JSON map.
  factory MultiLanguageValue.fromJson(Map<String, dynamic> json) {
    return MultiLanguageValue(
      language: json['language'] as String,
      text: json['text'] as String,
    );
  }
}

/// Represents a Value ID, similar to SemanticId, providing a reference to a value.
class ValueId {
  /// A list of keys that constitute the Value ID.
  final List<Key> keys;

  /// The type of the Value ID.
  final String type;

  /// Constructor for the ValueId class.
  ValueId({required this.keys, required this.type});

  /// Factory constructor to create a [ValueId] instance from a JSON map.
  factory ValueId.fromJson(Map<String, dynamic> json) {
    return ValueId(
      keys:
          (json['keys'] as List<dynamic>)
              .map((e) => Key.fromJson(e as Map<String, dynamic>))
              .toList(),
      type: json['type'] as String,
    );
  }
}

/// Parses a JSON string into a [Submodel] object.
///
/// Throws [FormatException] if the input string is not valid JSON.
/// Throws [TypeError] if the JSON structure does not match the Submodel model.
Submodel parseSubmodel(String jsonString) {
  final Map<String, dynamic> jsonMap =
      jsonDecode(jsonString) as Map<String, dynamic>;
  return Submodel.fromJson(jsonMap);
}
