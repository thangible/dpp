import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';

class MachineDiscoveryService {
  List<AasResponse>? responses;
  List<String> allIds = [];

  Future<List<AasResponse>> fetchFullMachineData() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final jsonPaths =
        manifestMap.keys
            .where(
              (String key) =>
                  key.startsWith('assets/data/') && key.endsWith('.json'),
            )
            .toList();

    List<AasResponse> responses = [];

    for (String path in jsonPaths) {
      print('Loading JSON from $path');
      try {
        final String jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        responses.add(AasResponse.fromJson(jsonMap));
      } catch (e) {
        print('Error parsing $path: $e');
      }
    }
    this.responses = responses;
    return responses;
  }

  String? get firstRootId =>
      responses?.first.assetAdministrationShells?.first.idShort;

  List<String> get allRootIds {
    if (responses == null) return [];

    List<String> allIds = [];
    for (var response in responses!) {
      if (response.assetAdministrationShells != null) {
        for (var shell in response.assetAdministrationShells!) {
          allIds.add(shell.idShort!);
        }
      }
    }

    this.allIds = allIds;
return allIds;
  }

  
}

