// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dpp/app/services/aas_client.dart';
// import 'package:dpp/app/data/submodel.dart';

// class SearchController extends GetxController {
//   final textController = TextEditingController();
//   var machineIds = <String>[].obs;
//   var searchHistory = <String>[].obs;
//   var filteredSuggestions = <String>[].obs;
//   var query = ''.obs;
//   var showSuggestions = false.obs;
//   var isLoading = false.obs;

//   // AAS Client instance
//   // late final AasClient _aasClient;

//   @override
//   void onInit() {
//     super.onInit();
//     _aasClient = AasClient();
//     _loadMachineIds();

//     // Update our query whenever the text field value changes.
//     textController.addListener(() {
//       query.value = textController.text;
//     });

//     // Whenever query changes, update suggestions.
//     ever(query, (_) => _filterSuggestions());
//   }

//   @override
//   void onClose() {

//     textController.dispose();
//     super.onClose();
//   }

//   Future<void> _loadMachineIds() async {
//     try {
//       isLoading.value = true;

//       // First, get all submodels (this returns basic info with IDs)
  


//       // Extract machine IDs from Digital Nameplate submodels
//       List<String> ids = [];


      
//         try {
//           for (var submodel in submodels) {
//             // Check if this is a Digital Nameplate submodel by looking at semanticId
//           final semanticId = submodel['semanticId'];
//           bool isDigitalNameplate = false;

//           if (semanticId != null && semanticId['keys'] != null) {
//             final keys = semanticId['keys'] as List<dynamic>;
//             isDigitalNameplate = keys.any(
//               (key) =>
//                   key['value']?.toString().contains('nameplate') == true ||
//                   key['value']?.toString().contains('DigitalNameplate') == true,
//             );
//           }

//           if (isDigitalNameplate) {
//             // Get the submodel ID to fetch detailed information
//             final submodelId = submodel['id'];

//             // Now fetch the detailed submodel using getSubmodel
//             final detailedSubmodel = await _aasClient.submodels.getSubmodel(
//               submodelId,
//               level: 'deep',
//               extent: 'withBlobValue',
//             );

//             // Extract machine IDs from submodel elements
//             final submodelElements =
//                 detailedSubmodel['submodelElements'] as List<dynamic>?;
//             if (submodelElements != null) {
//               for (var element in submodelElements) {
//                 // Look for machine ID in different possible locations
//                 final idShort = element['idShort']?.toString();
//                 if (idShort == 'SerialNumber' ||
//                     idShort == 'ManufacturerProductType' ||
//                     idShort == 'OrderCodeOfManufacturer' ||
//                     idShort == 'ProductArticleNumberOfManufacturer') {
//                   // Handle different element types
//                   String? value;
//                   if (element['modelType'] == 'Property') {
//                     value = element['value']?.toString();
//                   } else if (element['modelType'] == 'MultiLanguageProperty') {
//                     final valueArray = element['value'] as List<dynamic>?;
//                     if (valueArray != null && valueArray.isNotEmpty) {
//                       value = valueArray.first['text']?.toString();
//                       // Remove quotes if present
//                       if (value != null &&
//                           value.startsWith('"') &&
//                           value.endsWith('"')) {
//                         value = value.substring(1, value.length - 1);
//                       }
//                     }
//                   }

//                   if (value != null && value.isNotEmpty) {
//                     ids.add(value);
//                   }
//                 }
//               }
//             }
//           }
//           }
          
//         } catch (e) {
//           print('Error processing submodel: $e');
//           // Continue with next submodel
//         }
      

//       // Remove duplicates and sort
//       ids = ids.toSet().toList()..sort();
//       machineIds.assignAll(ids);
//     } catch (e) {
//       print('Error loading machine IDs from AAS: $e');
//       // Fallback to empty list or show error message
//       machineIds.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void _filterSuggestions() {
//     if (query.value.isEmpty) {
//       filteredSuggestions.assignAll(searchHistory);
//     } else {
//       filteredSuggestions.assignAll(
//         machineIds.where(
//           (id) => id.toLowerCase().contains(query.value.toLowerCase()),
//         ),
//       );
//     }
//   }

//   void handleSelection(String machineId) {
//     textController.text = machineId;
//     showSuggestions.value = false;

//     // Update search history.
//     if (searchHistory.contains(machineId)) {
//       searchHistory.remove(machineId);
//     }
//     if (searchHistory.length >= 5) {
//       searchHistory.removeLast();
//     }
//     searchHistory.insert(0, machineId);
//   }

//   /// Refresh machine IDs from AAS
//   Future<void> refreshMachineIds() async {
//     await _loadMachineIds();
//   }

//   /// Get detailed information for a specific machine ID
//   Future<Map<String, dynamic>?> getMachineDetails(String machineId) async {
//     try {
//       // First, get all submodels
//       final response = await _aasClient.submodels.getAllSubmodels();
//       final List<dynamic> submodels = response['result'] ?? [];

//       for (var submodel in submodels) {
//         try {
//           // Check if this is a Digital Nameplate submodel
//           final semanticId = submodel['semanticId'];
//           bool isDigitalNameplate = false;

//           if (semanticId != null && semanticId['keys'] != null) {
//             final keys = semanticId['keys'] as List<dynamic>;
//             isDigitalNameplate = keys.any(
//               (key) =>
//                   key['value']?.toString().contains('nameplate') == true ||
//                   key['value']?.toString().contains('DigitalNameplate') == true,
//             );
//           }

//           if (isDigitalNameplate) {
//             // Get detailed submodel
//             final detailedSubmodel = await _aasClient.submodels.getSubmodel(
//               submodel['id'],
//               level: 'deep',
//               extent: 'withBlobValue',
//             );

//             // Check if this submodel contains the machine ID
//             final submodelElements =
//                 detailedSubmodel['submodelElements'] as List<dynamic>?;
//             if (submodelElements != null) {
//               bool containsMachineId = false;

//               for (var element in submodelElements) {
//                 String? value;
//                 if (element['modelType'] == 'Property') {
//                   value = element['value']?.toString();
//                 } else if (element['modelType'] == 'MultiLanguageProperty') {
//                   final valueArray = element['value'] as List<dynamic>?;
//                   if (valueArray != null && valueArray.isNotEmpty) {
//                     value = valueArray.first['text']?.toString();
//                     // Remove quotes if present
//                     if (value != null &&
//                         value.startsWith('"') &&
//                         value.endsWith('"')) {
//                       value = value.substring(1, value.length - 1);
//                     }
//                   }
//                 }

//                 if (value == machineId) {
//                   containsMachineId = true;
//                   break;
//                 }
//               }

//               if (containsMachineId) {
//                 // Return the detailed submodel data
//                 return detailedSubmodel;
//               }
//             }
//           }
//         } catch (e) {
//           print('Error processing submodel ${submodel['id']}: $e');
//         }
//       }

//       return null;
//     } catch (e) {
//       print('Error getting machine details: $e');
//       return null;
//     }
//   }
// }
