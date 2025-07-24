import 'package:dpp/app/services/subservice/submodel/microservices/submodel_core_service.dart';
import 'package:dpp/app/services/subservice/submodel/microservices/submodel_element_service.dart';
import 'package:dpp/app/services/subservice/submodel/microservices/submodel_value_service.dart';
import 'package:dpp/app/services/subservice/submodel/microservices/submodel_metadata_service.dart';
import 'package:dpp/app/services/subservice/submodel/microservices/submodel_operation_service.dart';
import 'package:dpp/app/services/subservice/submodel/microservices/submodel_registry_service.dart';
import 'package:dpp/app/services/subservice/submodel/shell/submodel_parser.dart';

class SubmodelApiService {
  late final SubmodelCoreService _coreService;
  late final SubmodelElementService _elementService;
  late final SubmodelValueService _valueService;
  late final SubmodelMetadataService _metadataService;
  late final SubmodelOperationService _operationService;
  late final SubmodelRegistryService _registryService;
  late final SubmodelParser _parser;

  SubmodelApiService() {
    _parser = SubmodelParser();
    _coreService = SubmodelCoreService(parser: _parser);
    _elementService = SubmodelElementService();
    _valueService = SubmodelValueService();
    _metadataService = SubmodelMetadataService();
    _operationService = SubmodelOperationService();
    _registryService = SubmodelRegistryService();
  }

  // Core Submodel Operations
  Future<String> fetchSubmodels() => _coreService.fetchSubmodels();
  Future<dynamic> getSubmodel(
    String submodelId, {
    String? level,
    String? extent,
  }) => _coreService.getSubmodel(submodelId, level: level, extent: extent);
  Future<dynamic> getAllSubmodels() => _coreService.getAllSubmodels();
  Future<dynamic> createSubmodel(Map<String, dynamic> submodelData) =>
      _coreService.createSubmodel(submodelData);
  Future<void> updateSubmodel(
    String submodelId,
    Map<String, dynamic> submodelData,
  ) => _coreService.updateSubmodel(submodelId, submodelData);
  Future<void> deleteSubmodel(String submodelId) =>
      _coreService.deleteSubmodel(submodelId);
  Future<dynamic> getSubmodels(List<String> submodelIds) =>
      _coreService.getSubmodels(submodelIds);
  Future<dynamic> getSubmodelResults(List<String> submodelIds) =>
      _coreService.getSubmodelResults(submodelIds);

  // Submodel Element Operations
  Future<dynamic> getSubmodelElements(String submodelId) =>
      _elementService.getSubmodelElements(submodelId);
  Future<dynamic> createSubmodelElement(
    String submodelId,
    Map<String, dynamic> elementData,
  ) => _elementService.createSubmodelElement(submodelId, elementData);
  Future<dynamic> getSubmodelElement(String submodelId, String idShortPath) =>
      _elementService.getSubmodelElement(submodelId, idShortPath);
  Future<void> updateSubmodelElement(
    String submodelId,
    String idShortPath,
    Map<String, dynamic> elementData,
  ) => _elementService.updateSubmodelElement(
    submodelId,
    idShortPath,
    elementData,
  );
  Future<dynamic> createSubmodelElementAtPath(
    String submodelId,
    String idShortPath,
    Map<String, dynamic> elementData,
  ) => _elementService.createSubmodelElementAtPath(
    submodelId,
    idShortPath,
    elementData,
  );
  Future<void> deleteSubmodelElement(String submodelId, String idShortPath) =>
      _elementService.deleteSubmodelElement(submodelId, idShortPath);

  // Value Operations
  Future<dynamic> getSubmodelValue(String submodelId) =>
      _valueService.getSubmodelValue(submodelId);
  Future<void> updateSubmodelValue(
    String submodelId,
    Map<String, dynamic> values,
  ) => _valueService.updateSubmodelValue(submodelId, values);
  Future<dynamic> getSubmodelElementValue(
    String submodelId,
    String idShortPath,
  ) => _valueService.getSubmodelElementValue(submodelId, idShortPath);
  Future<void> updateSubmodelElementValue(
    String submodelId,
    String idShortPath,
    dynamic value,
  ) => _valueService.updateSubmodelElementValue(submodelId, idShortPath, value);

  // Metadata Operations
  Future<dynamic> getSubmodelMetadata(String submodelId) =>
      _metadataService.getSubmodelMetadata(submodelId);

  // Operation Invocation
  Future<dynamic> invokeOperation(
    String submodelId,
    String idShortPath,
    Map<String, dynamic> operationRequest,
  ) => _operationService.invokeOperation(
    submodelId,
    idShortPath,
    operationRequest,
  );

  // Registry Operations
  Future<String> fetchSubmodelDescriptors() =>
      _registryService.fetchSubmodelDescriptors();

  // Parser Operations
  dynamic parseSubmodel(String jsonString) => _parser.parseSubmodel(jsonString);
  dynamic parseSubmodels(String jsonString) =>
      _parser.parseSubmodels(jsonString);
}
