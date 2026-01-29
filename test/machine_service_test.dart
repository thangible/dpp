import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/services/test/machineServiceJson.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final _machineService = MachineDiscoveryService();

  test('Print all machine IDs', () async {
    try {
      final responses = await _machineService.fetchFullMachineData();
      String? machineId = _machineService.firstRootId;
      // print('Discovered Machine IDs:');
      // print('  - $machineId');
      List<String> allIds = _machineService.allRootIds;
      for (var id in allIds) {
        print('  - $id');
      }

      print('Found ${responses.length} machines:');
      print('=' * 80);

      for (int i = 0; i < responses.length; i++) {
        final response = responses[i];
        print('\n🏭 MACHINE ${i + 1}:');
        print('-' * 40);

        // Print AAS information
        if (response.assetAdministrationShells?.isNotEmpty == true) {
          final aas = response.assetAdministrationShells!.first;
          print('📋 Asset Administration Shell:');
          print('  ID: ${aas.id}');
          print('  ID Short: ${aas.idShort}');
          print('  Model Type: ${aas.modelType}');

          if (aas.assetInformation != null) {
            print('🏗️  Asset Information:');
            print(
              '    Global Asset ID: ${aas.assetInformation!.globalAssetId}',
            );
            print('    Asset Kind: ${aas.assetInformation!.assetKind}');
            print(
              '    Asset Type: ${aas.assetInformation!.assetType ?? 'N/A'}',
            );
          }

          if (aas.submodels?.isNotEmpty == true) {
            print('🔗 Submodel References: ${aas.submodels!.length}');
            for (var ref in aas.submodels!) {
              print('    - Type: ${ref.type}, Keys: ${ref.keys?.length ?? 0}');
              if (ref.keys?.isNotEmpty == true) {
                print(
                  '      Key: ${ref.keys!.first.type} = ${ref.keys!.first.value}',
                );
              }
            }
          }
        }

        // Print detailed submodel information
        if (response.submodels?.isNotEmpty == true) {
          print('\n📦 SUBMODELS (${response.submodels!.length}):');

          for (int j = 0; j < response.submodels!.length; j++) {
            final sm = response.submodels![j];
            print('\n  📋 Submodel ${j + 1}:');
            print('    ID: ${sm.id}');
            print('    ID Short: ${sm.idShort}');
            print('    Model Type: ${sm.modelType}');
            print('    Kind: ${sm.kind}');

            // Display Name
            if (sm.displayName?.isNotEmpty == true) {
              print('    Display Name:');
              for (var langString in sm.displayName!) {
                print('      [${langString.language}]: ${langString.text}');
              }
            }

            // Description
            if (sm.description?.isNotEmpty == true) {
              print('    Description:');
              for (var langString in sm.description!) {
                print('      [${langString.language}]: ${langString.text}');
              }
            }

            // Semantic ID
            if (sm.semanticId != null) {
              print('    🏷️  Semantic ID:');
              print('      Type: ${sm.semanticId!.type}');
              if (sm.semanticId!.keys?.isNotEmpty == true) {
                for (var key in sm.semanticId!.keys!) {
                  print('      Key: ${key.type} = ${key.value}');
                }
              }
            }

            // Administration
            if (sm.administration != null) {
              print('    ⚙️  Administration:');
              print('      Version: ${sm.administration!.version ?? 'N/A'}');
              print('      Revision: ${sm.administration!.revision ?? 'N/A'}');
              print(
                '      Template ID: ${sm.administration!.templateId ?? 'N/A'}',
              );
            }

            // Submodel Elements
            if (sm.submodelElements?.isNotEmpty == true) {
              print(
                '    🧩 Submodel Elements (${sm.submodelElements!.length}):',
              );

              for (int k = 0; k < sm.submodelElements!.length; k++) {
                final element = sm.submodelElements![k];
                print('\n      Element ${k + 1}:');
                print('        ID Short: ${element.idShort}');
                print('        Model Type: ${element.modelType}');
                print('        Category: ${element.category ?? 'N/A'}');

                // Element Display Name
                if (element.displayName?.isNotEmpty == true) {
                  print('        Display Name:');
                  for (var langString in element.displayName!) {
                    print(
                      '          [${langString.language}]: ${langString.text}',
                    );
                  }
                }

                // Element Description
                if (element.description?.isNotEmpty == true) {
                  print('        Description:');
                  for (var langString in element.description!) {
                    print(
                      '          [${langString.language}]: ${langString.text}',
                    );
                  }
                }

                // Element Semantic ID
                if (element.semanticId != null) {
                  print('        Semantic ID: ${element.semanticId!.type}');
                  if (element.semanticId!.keys?.isNotEmpty == true) {
                    for (var key in element.semanticId!.keys!) {
                      print('          ${key.type} = ${key.value}');
                    }
                  }
                }

                // Type-specific information
                if (element is Property) {
                  print('        💎 Property Value: ${element.value}');
                  print('        Value Type: ${element.valueType ?? 'N/A'}');
                } else if (element is FileSubmodelElement) {
                  print('        📁 File Path: ${element.value}');
                  print('        Content Type: ${element.contentType}');
                } else if (element is MultiLanguageProperty) {
                  print('        🌐 Multi-Language Values:');
                  for (var langString in element.value) {
                    print(
                      '          [${langString.language}]: ${langString.text}',
                    );
                  }
                } else if (element is SubmodelElementCollection) {
                  print(
                    '        📦 Collection Elements: ${element.value?.length ?? 0}',
                  );
                } else if (element is SubmodelElementList) {
                  print(
                    '        📋 List Elements: ${element.value?.length ?? 0}',
                  );
                  print(
                    '        Order Relevant: ${element.orderRelevant ?? false}',
                  );
                  print(
                    '        Type Value List Element: ${element.typeValueListElement ?? 'N/A'}',
                  );
                }

                // Qualifiers
                if (element.qualifiers?.isNotEmpty == true) {
                  print(
                    '        🏷️  Qualifiers (${element.qualifiers!.length}):',
                  );
                  for (var qualifier in element.qualifiers!) {
                    print(
                      '          ${qualifier.type}: ${qualifier.value} (${qualifier.valueType})',
                    );
                  }
                }
              }
            } else {
              print('    🧩 Submodel Elements: None');
            }
          }
        } else {
          print('\n📦 SUBMODELS: None found');
        }

        // Print concept descriptions
        if (response.conceptDescriptions?.isNotEmpty == true) {
          print(
            '\n📖 CONCEPT DESCRIPTIONS (${response.conceptDescriptions!.length}):',
          );
          for (int j = 0; j < response.conceptDescriptions!.length; j++) {
            final cd = response.conceptDescriptions![j];
            print('  ${j + 1}. ID: ${cd.id}');
            print('     ID Short: ${cd.idShort}');
            print('     Model Type: ${cd.modelType}');
            if (cd.description?.isNotEmpty == true) {
              print('     Description: ${cd.description!.first.text}');
            }
          }
        }

        print('\n' + '=' * 80);
      }

      print('\n✅ Summary: Successfully processed ${responses.length} machines');
    } catch (e) {
      print('❌ Error fetching machine data: $e');
    }
  });
}
