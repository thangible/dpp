import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

void main() {
  test('Should deserialize mock_printerAAS.json into AasResponse', () async {
    // 1. Load the JSON file from your assets directory
    final file = File('assets/data/mock_printerAAS.json');
    final String jsonString = await file.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // 2. Perform deserialization
    final aasResponse = AasResponse.fromJson(jsonMap);

    // 3. Verify Shell data
    expect(aasResponse.assetAdministrationShells, isNotEmpty);
    final shell = aasResponse.assetAdministrationShells!.first;
    expect(shell.idShort, 'PrinterAAS');
    expect(shell.assetInformation?.assetType, '3DPrinter');

    // 4. Verify Submodels and polymorphic elements
    expect(aasResponse.submodels, isNotEmpty);

    // Test the "Nameplate" submodel
    final nameplate = aasResponse.submodels!.firstWhere(
      (s) => s.idShort == 'Nameplate',
    );
    expect(nameplate.submodelElements, isNotNull);

    // Verify a MultiLanguageProperty (ManufacturerName)
    final manufacturer =
        nameplate.submodelElements!.firstWhere(
              (e) => e.idShort == 'ManufacturerName',
            )
            as MultiLanguageProperty;
    expect(manufacturer.value.first.text, 'Fraunhofer IAPT');

    // Verify a nested SubmodelElementCollection (Address)
    final address =
        nameplate.submodelElements!.firstWhere((e) => e.idShort == 'Address')
            as SubmodelElementCollection;
    expect(address.value, isNotEmpty);

    // Verify a Property inside the collection (Street)
    final street =
        address.value!.firstWhere((e) => e.idShort == 'Street')
            as MultiLanguageProperty;
    expect(street.value.first.text, 'TBD');

    print(
      '✓ Deserialization successful: ${shell.idShort} and its submodels parsed correctly.',
    );
  });
}


