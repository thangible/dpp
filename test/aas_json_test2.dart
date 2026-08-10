import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

void main() {
  test('Extract AAS Property Values', () {
    final file = File('assets/data/mock_printerAAS.json');
    final jsonMap = jsonDecode(file.readAsStringSync());
    final response = AasResponse.fromJson(jsonMap);

    // Look specifically in the CarbonFootprint submodel for emissions data
    final footprintSubmodel = response.submodels?.firstWhere(
      (s) => s.idShort == "CarbonFootprint",
      orElse: () => throw Exception("CarbonFootprint submodel not found"),
    );

    print('--- Extracted Values ---');

    // Helper to find a value by idShort within a list of elements
    String findValue(List<SubmodelElement>? elements, String idShort) {
      try {
        final element = elements?.firstWhere((e) => e.idShort == idShort);
        if (element is Property) return element.value.toString();
        if (element is MultiLanguageProperty) {
          return element.value.first.text ?? "";
        }
        return "Not a Property";
      } catch (_) {
        return "Not Found";
      }
    }

    // Navigating the specific nested structure of your CarbonFootprint JSON
    final pcfList =
        footprintSubmodel?.submodelElements?.firstWhere(
              (e) => e.idShort == "ProductCarbonFootprints",
            )
            as SubmodelElementList?;

    final pcfCollection = pcfList?.value?.first as SubmodelElementCollection?;

    // Print similar keys found in your provided JSON structure
    print('CO2 Equivalent: ${findValue(pcfCollection?.value, "PcfCO2eq")}');
    print(
      'Manufacturer (Nameplate): ${findValue(response.submodels?[0].submodelElements, "ManufacturerName")}',
    );

    // For values not in the mock but in your request (like recycledMaterial),
    // it would look like this if they existed in the collection:
    print(
      'Recycled Material: ${findValue(pcfCollection?.value, "recycledMaterial")}',
    );
  });
}
