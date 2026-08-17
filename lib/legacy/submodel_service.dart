// // lib/services/submodel_service.dart
// import 'dart:convert'; // For utf8.encode for file uploads and base64UrlEncode
// import 'package:dio/dio.dart';
// import 'package:dpp/app/services/api/basyx_api_client.dart'; // Adjust import path as needed
// import 'package:dpp/app/data_model/api/generic_submodel.dart';
// import 'package:dpp/app/services/api/dio_aux.dart'; // Adjust import path as needed

// String utf8Base64UrlEncode(String input) {
//   final bytes = utf8.encode(input);
//   return base64.encode(bytes).replaceAll('=', '');
// }

// class SubmodelService {
//   final BaSyxApiClient _apiClient;

//   SubmodelService() : _apiClient = BaSyxApiClient(DioFactory.aasService);

//   // --- Submodel Repository API ---

//   /// Returns all Submodels (now correctly parses the generic PagingResponse)
//   Future<List<Submodel>> getAllSubmodels() async {
//     final response = await _apiClient.getAllSubmodels();
//     return response
//         .result; // Extract the list of submodels from the result field
//   }

//   /// Creates a new Submodel
//   Future<Submodel> createSubmodel(Submodel submodel) async {
//     return await _apiClient.createSubmodel(submodel);
//   }

//   /// Returns a specific Submodel
//   Future<Submodel> getSubmodel(
//     String submodelIdentifier, {
//     String? level,
//     String? extent,
//   }) async {
//     // Apply encoding if the identifier itself needs it before being passed to Retrofit
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     print('Encoded Submodel Identifier: $encodedSubmodelIdentifier');
//     return await _apiClient.getSubmodel(
//       encodedSubmodelIdentifier,
//       level,
//       extent,
//     );
//   }

//   /// Updates an existing Submodel
//   Future<void> updateSubmodel(
//     String submodelIdentifier,
//     Submodel submodel,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     await _apiClient.updateSubmodel(encodedSubmodelIdentifier, submodel);
//   }

//   /// Deletes a Submodel
//   Future<void> deleteSubmodel(String submodelIdentifier) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     await _apiClient.deleteSubmodel(encodedSubmodelIdentifier);
//   }

//   /// Returns a specific submodel element from the Submodel at a specified path
//   /// Returns a dynamic map, which you can then parse into specific SubmodelElement types.
//   Future<Map<String, dynamic>> getSubmodelElement(
//     String submodelIdentifier,
//     String idShortPath,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(
//       idShortPath,
//     ); // Encode path if needed
//     return await _apiClient.getSubmodelElement(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//     );
//   }

//   /// Updates an existing submodel element at a specified path
//   Future<void> updateSubmodelElement(
//     String submodelIdentifier,
//     String idShortPath,
//     Map<String, dynamic> elementData,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     await _apiClient.updateSubmodelElement(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//       elementData,
//     );
//   }

//   /// Creates a new submodel element at a specified path
//   Future<Map<String, dynamic>> createSubmodelElementAtPath(
//     String submodelIdentifier,
//     String idShortPath,
//     Map<String, dynamic> elementData,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     return await _apiClient.createSubmodelElementAtPath(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//       elementData,
//     );
//   }

//   /// Deletes a submodel element at a specified path
//   Future<void> deleteSubmodelElement(
//     String submodelIdentifier,
//     String idShortPath,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     await _apiClient.deleteSubmodelElement(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//     );
//   }

//   // /// Returns all submodel elements including their hierarchy
//   // /// Returns a dynamic list, which you can then parse into specific SubmodelElement types.
//   // Future<List<Map<String, dynamic>>> getAllSubmodelElements(
//   //   String submodelIdentifier,
//   // ) async {
//   //   final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//   //   return await _apiClient.getAllSubmodelElements(encodedSubmodelIdentifier);
//   // }

//   /// Creates a new submodel element
//   /// Returns a dynamic map.
//   Future<Map<String, dynamic>> createSubmodelElement(
//     String submodelIdentifier,
//     Map<String, dynamic> elementData,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     return await _apiClient.createSubmodelElement(
//       encodedSubmodelIdentifier,
//       elementData,
//     );
//   }

//   /// Synchronously or asynchronously invokes an Operation at a specified path
//   Future<OperationResponse> invokeOperation(
//     String submodelIdentifier,
//     String idShortPath,
//     OperationRequest operationRequest,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     return await _apiClient.invokeOperation(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//       operationRequest,
//     );
//   }

//   /// Returns a specific submodel element value
//   Future<dynamic> getSubmodelElementValue(
//     String submodelIdentifier,
//     String idShortPath,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     return await _apiClient.getSubmodelElementValue(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//     );
//   }

//   /// Updates the value of an existing SubmodelElement
//   Future<void> updateSubmodelElementValue(
//     String submodelIdentifier,
//     String idShortPath,
//     dynamic value,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     await _apiClient.updateSubmodelElementValue(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//       value,
//     );
//   }

//   // / Returns a specific Submodel in the ValueOnly representation
//   Future<Map<String, dynamic>> getSubmodelValue(
//     String submodelIdentifier,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     return await _apiClient.getSubmodelValue(encodedSubmodelIdentifier);
//   }

//   // /// Updates the values of an existing Submodel
//   Future<void> updateSubmodelValue(
//     String submodelIdentifier,
//     Map<String, dynamic> values,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     await _apiClient.updateSubmodelValue(encodedSubmodelIdentifier, values);
//   }

//   // /// Returns the metadata attributes of a specific Submodel
//   Future<Map<String, dynamic>> getSubmodelMetadata(
//     String submodelIdentifier,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     return await _apiClient.getSubmodelMetadata(encodedSubmodelIdentifier);
//   }

//   // --- Asset Administration Shell API (File Operations related to Submodels) ---

//   /// Downloads file content from a specific submodel element
//   Future<List<int>> downloadAttachment(
//     String submodelIdentifier,
//     String idShortPath,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     return await _apiClient.downloadAttachment(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//     );
//   }

//   /// Uploads file content to an existing submodel element
//   Future<void> uploadAttachment(
//     String submodelIdentifier,
//     String idShortPath,
//     List<int> bytes,
//     String filename,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     final multipartFile = MultipartFile.fromBytes(bytes, filename: filename);
//     final formData = FormData.fromMap({'file': multipartFile});
//     await _apiClient.uploadAttachment(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//       formData,
//     );
//   }

//   /// Deletes file content of an existing submodel element
//   Future<void> deleteAttachment(
//     String submodelIdentifier,
//     String idShortPath,
//   ) async {
//     final encodedSubmodelIdentifier = utf8Base64UrlEncode(submodelIdentifier);
//     final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
//     await _apiClient.deleteAttachment(
//       encodedSubmodelIdentifier,
//       encodedIdShortPath,
//     );
//   }
// }
