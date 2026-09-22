import 'dart:typed_data';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

class Product {
  final String id;
  // energyUsed/co2Emissions represent the footprint of the manufacturing
  // *process* this product went through (there's no standalone Process
  // entity anymore — see legacy/ — its data lives here instead).
  final double? energyUsed;
  final double? co2Emissions;
  final double? processProgress; // 0-100%, from the old Process.progress
  final DateTime? lastUpdated;
  final String? type;
  final String? material;
  final String? materialId; // links to a Material (its own searchable entity)
  final String? manufacturer;
  final double? virginMaterial;
  final double? recycledMaterial;
  final String? imagePath;
  // Set when there's no filesystem to cache a downloaded thumbnail to (Flutter
  // Web — see BasyxLocalCache) so the bytes are kept in memory on the Product
  // itself instead of being handed off as a file:// path. ProductImageCard
  // prefers this over [imagePath] when both are present.
  final Uint8List? imageBytes;

  Product({
    required this.id,
    this.energyUsed,
    this.co2Emissions,
    this.processProgress,
    this.lastUpdated,
    this.type,
    this.material,
    this.materialId,
    this.manufacturer,
    this.virginMaterial,
    this.recycledMaterial,
    this.imagePath,
    this.imageBytes,
  });

  /// [resolvedImagePath], [resolvedImageBytes] and [resolvedMaterialId] are
  /// for when the caller already figured out something this factory can't
  /// get from the AAS JSON alone — e.g. BasyxSyncService downloading the
  /// thumbnail separately and linking a Material entry. Old call sites that
  /// skip these just work like before.
  factory Product.fromJson(
    AasResponse jsonResponse, {
    String? resolvedImagePath,
    Uint8List? resolvedImageBytes,
    String? resolvedMaterialId,
  }) {
    String productId = '';
    String? manufacturerName;
    String? productType;
    String? productDesignation;
    String? materialName;
    String? yearOfConstruction;
    double? co2Value;

    // Extract basic product ID
    if (jsonResponse.assetAdministrationShells?.isNotEmpty == true) {
      final aas = jsonResponse.assetAdministrationShells!.first;
      productId = aas.idShort;

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
              case 'ManufacturerProductDesignation':
                // fallback for "type" when there's no assetType (parts
                // don't usually have one, only machines seem to)
                if (element is MultiLanguageProperty &&
                    element.value.isNotEmpty) {
                  productDesignation = element.value.first.text;
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
                    // old mock files use 'ProductCarbonFootprintValue',
                    // real IDTA 02023 packages use 'PcfCO2eq' - take either
                    final isCo2Value =
                        fpElement.idShort == 'ProductCarbonFootprintValue' ||
                        fpElement.idShort == 'PcfCO2eq';
                    if (isCo2Value &&
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
        // grab the material name too, if this package has a DIN SPEC
        // 91481 material-data submodel sitting next to the product
        else if (idShort == 'MaterialData_DINSPEC91481' &&
            submodel.submodelElements != null) {
          for (var element in submodel.submodelElements!) {
            if (element.idShort == 'Materialbezeichnung' &&
                element is Property &&
                element.value != null) {
              materialName = element.value.toString();
            }
          }
        }
      }
    }

    return Product(
      id: productId,
      manufacturer: manufacturerName,
      type: productType ?? productDesignation,
      co2Emissions: co2Value,
      lastUpdated:
          yearOfConstruction != null
              ? DateTime.tryParse('$yearOfConstruction-01-01')
              : null,
      // These fields would need to be extracted from other submodels or elements
      energyUsed: null, // Not found in current structure
      material: materialName,
      materialId: resolvedMaterialId,
      virginMaterial: null, // Not found in current structure
      recycledMaterial: null, // Not found in current structure
      imagePath: resolvedImagePath ?? "No Image",
      imageBytes: resolvedImageBytes,
    );
  }
}
