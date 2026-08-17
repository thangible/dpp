// import 'package:dio/dio.dart';
// import 'package:dpp/app/services/api/submodel_service.dart';
// import 'package:dpp/app/data_model/api/generic_submodel.dart';
// import 'package:dpp/app/services/api/dio_aux.dart';
// import 'package:dpp/config/api/api_urls.dart';

// /// Service for managing Digital Nameplate submodels
// /// Uses the standard submodel identifier: https://admin-shell.io/idta/aas/DigitalNameplate/3/0
// class NameplateService {
//   static const String nameplateSubmodelId =
//       'https://admin-shell.io/idta/SubmodelTemplate/DigitalNameplate/3/0';

//   final SubmodelService _submodelService;

//   NameplateService() : _submodelService = SubmodelService();

//   // --- Digital Nameplate Specific Operations ---

//   /// Gets the Digital Nameplate submodel
//   Future<Submodel> getNameplateSubmodel({String? level, String? extent}) async {
//     Submodel nameplate = await _submodelService.getSubmodel(
//       nameplateSubmodelId,
//       level: level,
//       extent: extent,
//     );
//     return nameplate;
//   }

//   /// Creates a new Digital Nameplate submodel
//   Future<Submodel> createNameplateSubmodel(Submodel nameplate) async {
//     return await _submodelService.createSubmodel(nameplate);
//   }

//   /// Updates the Digital Nameplate submodel
//   Future<void> updateNameplateSubmodel(Submodel nameplate) async {
//     await _submodelService.updateSubmodel(nameplateSubmodelId, nameplate);
//   }

//   /// Deletes the Digital Nameplate submodel
//   Future<void> deleteNameplateSubmodel() async {
//     await _submodelService.deleteSubmodel(nameplateSubmodelId);
//   }

//   // --- Nameplate Element Operations ---

//   /// Gets manufacturer name from the nameplate
//   Future<String?> getManufacturerName() async {
//     try {
//       final element = await _submodelService.getSubmodelElement(
//         nameplateSubmodelId,
//         'manufacturerName',
//       );
//       return element['value'] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Sets manufacturer name in the nameplate
//   Future<void> setManufacturerName(String manufacturerName) async {
//     final elementData = {
//       'modelType': 'Property',
//       'idShort': 'manufacturerName',
//       'valueType': 'xs:string',
//       'value': manufacturerName,
//     };

//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       'manufacturerName',
//       elementData,
//     );
//   }

//   /// Gets product designation from the nameplate
//   Future<String?> getProductDesignation() async {
//     try {
//       final element = await _submodelService.getSubmodelElement(
//         nameplateSubmodelId,
//         'productDesignation',
//       );
//       return element['value'] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Sets product designation in the nameplate
//   Future<void> setProductDesignation(String productDesignation) async {
//     final elementData = {
//       'modelType': 'Property',
//       'idShort': 'productDesignation',
//       'valueType': 'xs:string',
//       'value': productDesignation,
//     };

//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       'productDesignation',
//       elementData,
//     );
//   }

//   /// Gets manufacturer product family from the nameplate
//   Future<String?> getManufacturerProductFamily() async {
//     try {
//       final element = await _submodelService.getSubmodelElement(
//         nameplateSubmodelId,
//         'manufacturerProductFamily',
//       );
//       return element['value'] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Sets manufacturer product family in the nameplate
//   Future<void> setManufacturerProductFamily(String productFamily) async {
//     final elementData = {
//       'modelType': 'Property',
//       'idShort': 'manufacturerProductFamily',
//       'valueType': 'xs:string',
//       'value': productFamily,
//     };

//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       'manufacturerProductFamily',
//       elementData,
//     );
//   }

//   /// Gets serial number from the nameplate
//   Future<String?> getSerialNumber() async {
//     try {
//       final element = await _submodelService.getSubmodelElement(
//         nameplateSubmodelId,
//         'SerialNumber',
//       );
//       return element['value'] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Sets serial number in the nameplate
//   Future<void> setSerialNumber(String serialNumber) async {
//     final elementData = {
//       'modelType': 'Property',
//       'idShort': 'serialNumber',
//       'valueType': 'xs:string',
//       'value': serialNumber,
//     };

//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       'serialNumber',
//       elementData,
//     );
//   }

//   /// Gets year of construction from the nameplate
//   Future<String?> getYearOfConstruction() async {
//     try {
//       final element = await _submodelService.getSubmodelElement(
//         nameplateSubmodelId,
//         'yearOfConstruction',
//       );
//       return element['value'] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Sets year of construction in the nameplate
//   Future<void> setYearOfConstruction(String year) async {
//     final elementData = {
//       'modelType': 'Property',
//       'idShort': 'yearOfConstruction',
//       'valueType': 'xs:gYear',
//       'value': year,
//     };

//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       'yearOfConstruction',
//       elementData,
//     );
//   }

//   /// Gets manufacturer product type from the nameplate
//   Future<String?> getManufacturerProductType() async {
//     try {
//       final element = await _submodelService.getSubmodelElement(
//         nameplateSubmodelId,
//         'manufacturerProductType',
//       );
//       return element['value'] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Sets manufacturer product type in the nameplate
//   Future<void> setManufacturerProductType(String productType) async {
//     final elementData = {
//       'modelType': 'Property',
//       'idShort': 'manufacturerProductType',
//       'valueType': 'xs:string',
//       'value': productType,
//     };

//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       'manufacturerProductType',
//       elementData,
//     );
//   }

//   // --- Batch Operations ---

//   /// Gets all nameplate data as a map
//   Future<Map<String, dynamic>> getAllNameplateData() async {
//     return await _submodelService.getSubmodelValue(nameplateSubmodelId);
//   }

//   /// Updates multiple nameplate values at once
//   Future<void> updateNameplateData(Map<String, dynamic> values) async {
//     await _submodelService.updateSubmodelValue(nameplateSubmodelId, values);
//   }

//   /// Gets a specific nameplate element by idShort
//   Future<Map<String, dynamic>> getNameplateElement(String idShort) async {
//     return await _submodelService.getSubmodelElement(
//       nameplateSubmodelId,
//       idShort,
//     );
//   }

//   /// Creates a new nameplate element
//   Future<Map<String, dynamic>> createNameplateElement(
//     Map<String, dynamic> elementData,
//   ) async {
//     return await _submodelService.createSubmodelElement(
//       nameplateSubmodelId,
//       elementData,
//     );
//   }

//   /// Updates a nameplate element
//   Future<void> updateNameplateElement(
//     String idShort,
//     Map<String, dynamic> elementData,
//   ) async {
//     await _submodelService.updateSubmodelElement(
//       nameplateSubmodelId,
//       idShort,
//       elementData,
//     );
//   }

//   /// Deletes a nameplate element
//   Future<void> deleteNameplateElement(String idShort) async {
//     await _submodelService.deleteSubmodelElement(nameplateSubmodelId, idShort);
//   }

//   // --- File Operations for Nameplate ---

//   /// Downloads an attachment from the nameplate (e.g., product image)
//   Future<List<int>> downloadNameplateAttachment(String idShort) async {
//     return await _submodelService.downloadAttachment(
//       nameplateSubmodelId,
//       idShort,
//     );
//   }

//   /// Uploads an attachment to the nameplate
//   Future<void> uploadNameplateAttachment(
//     String idShort,
//     List<int> bytes,
//     String filename,
//   ) async {
//     await _submodelService.uploadAttachment(
//       nameplateSubmodelId,
//       idShort,
//       bytes,
//       filename,
//     );
//   }

//   /// Deletes an attachment from the nameplate
//   Future<void> deleteNameplateAttachment(String idShort) async {
//     await _submodelService.deleteAttachment(nameplateSubmodelId, idShort);
//   }

//   // --- Helper Methods ---

//   // /// Creates a standard Digital Nameplate submodel structure
//   // Submodel createStandardNameplateSubmodel({
//   //   required String manufacturerName,
//   //   required String productDesignation,
//   //   String? serialNumber,
//   //   String? yearOfConstruction,
//   //   String? manufacturerProductFamily,
//   //   String? manufacturerProductType,
//   // }) {
//   //   final elements = <SubmodelElement>[
//   //     Property(
//   //       modelType: 'Property',
//   //       idShort: 'manufacturerName',
//   //       valueType: 'xs:string',
//   //       value: manufacturerName,
//   //     ),
//   //     Property(
//   //       modelType: 'Property',
//   //       idShort: 'productDesignation',
//   //       valueType: 'xs:string',
//   //       value: productDesignation,
//   //     ),
//   //   ];

//   //   if (serialNumber != null) {
//   //     elements.add(
//   //       Property(
//   //         modelType: 'Property',
//   //         idShort: 'serialNumber',
//   //         valueType: 'xs:string',
//   //         value: serialNumber,
//   //       ),
//   //     );
//   //   }

//   //   if (yearOfConstruction != null) {
//   //     elements.add(
//   //       Property(
//   //         modelType: 'Property',
//   //         idShort: 'yearOfConstruction',
//   //         valueType: 'xs:gYear',
//   //         value: yearOfConstruction,
//   //       ),
//   //     );
//   //   }

//   //   if (manufacturerProductFamily != null) {
//   //     elements.add(
//   //       Property(
//   //         modelType: 'Property',
//   //         idShort: 'manufacturerProductFamily',
//   //         valueType: 'xs:string',
//   //         value: manufacturerProductFamily,
//   //       ),
//   //     );
//   //   }

//   //   if (manufacturerProductType != null) {
//   //     elements.add(
//   //       Property(
//   //         modelType: 'Property',
//   //         idShort: 'manufacturerProductType',
//   //         valueType: 'xs:string',
//   //         value: manufacturerProductType,
//   //       ),
//   //     );
//   //   }

//   //   return Submodel(
//   //     modelType: 'Submodel',
//   //     id: nameplateSubmodelId,
//   //     idShort: 'DigitalNameplate',
//   //     semanticId: Reference(
//   //       type: 'ExternalReference',
//   //       keys: [Key(type: 'GlobalReference', value: nameplateSubmodelId)],
//   //     ),
//   //     submodelElements: elements,
//   //   );
//   // }
// }
