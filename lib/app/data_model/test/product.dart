import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

class Product {
  final String id;
  final double? energyUsed;
  final double? co2Emissions;
  final DateTime? lastUpdated;
  final String? type;
  final String? material;
  final String? manufacturer;
  final double? virginMaterial;
  final double? recycledMaterial;
  final String? imagePath;

  Product({
    required this.id,
    this.energyUsed,
    this.co2Emissions,
    this.lastUpdated,
    this.type,
    this.material,
    this.manufacturer,
    this.virginMaterial,
    this.recycledMaterial,
    this.imagePath,
  });

  factory Product.fromJson(AasResponse jsonResponse) {
    String product_id = '';
    String? manufacturerName;
    String? productType;
    String? yearOfConstruction;
    double? co2Value;

    // Extract basic product ID
    if (jsonResponse.assetAdministrationShells?.isNotEmpty == true) {
      final aas = jsonResponse.assetAdministrationShells!.first;
      product_id = aas.idShort;

      // Extract asset type from asset information
      if (aas.assetInformation != null) {
        productType = aas.assetInformation!.assetType;
      }
    }

    // Extract detailed information from submodels
    if (jsonResponse.submodels?.isNotEmpty == true) {
      final submodels = jsonResponse.submodels!;

      for (var submodel in submodels) {
        final idShort = submodel.idShort;

        // Extract nameplate information
        if (idShort == 'Nameplate' && submodel.submodelElements != null) {
          final elements = submodel.submodelElements!;

          for (var element in elements) {
            final elementIdShort = element.idShort;

            switch (elementIdShort) {
              case 'ManufacturerName':
                if (element is MultiLanguageProperty &&
                    element.value.isNotEmpty) {
                  manufacturerName = element.value.first.text;
                }
                break;
              case 'YearOfConstruction':
                if (element is Property && element.value != null) {
                  yearOfConstruction = element.value.toString();
                }
                break;
            }
          }
        }
        // Extract carbon footprint information
        else if (idShort == 'CarbonFootprint' &&
            submodel.submodelElements != null) {
          final elements = submodel.submodelElements!;

          for (var element in elements) {
            if (element.idShort == 'ProductCarbonFootprints' &&
                element is SubmodelElementList &&
                element.value != null) {
              final footprintList = element.value!;

              // Extract CO2 value from the first footprint entry
              if (footprintList.isNotEmpty) {
                final footprint = footprintList.first;
                if (footprint is SubmodelElementCollection &&
                    footprint.value != null) {
                  final footprintElements = footprint.value!;

                  for (var fpElement in footprintElements) {
                    if (fpElement.idShort == 'ProductCarbonFootprintValue' &&
                        fpElement is Property &&
                        fpElement.value != null) {
                      co2Value = double.tryParse(fpElement.value.toString());
                      break;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return Product(
      id: product_id,
      manufacturer: manufacturerName,
      type: productType,
      co2Emissions: co2Value,
      lastUpdated:
          yearOfConstruction != null
              ? DateTime.tryParse('$yearOfConstruction-01-01')
              : null,
      // These fields would need to be extracted from other submodels or elements
      energyUsed: null, // Not found in current structure
      material: null, // Not found in current structure
      virginMaterial: null, // Not found in current structure
      recycledMaterial: null, // Not found in current structure
      imagePath: "No Image", // Not found in current structure
    );
  }
}
