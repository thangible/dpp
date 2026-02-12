import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/test/process.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

class ProcessService {
  static late final List<AasResponse>? responses;
  static late final Map<String, dynamic> manifestMap;
  static late final List<Process> processes;
  static late final Map<String, Process> processMap;

  static Future<void> init() async {
    List<AasResponse> tempResponses = [];
    final String manifestContent = await rootBundle.loadString(
      'AssetManifest.json',
    );
    manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final jsonPaths =
        manifestMap.keys
            .where(
              (String key) =>
                  key.startsWith('assets/data/') && key.endsWith('.json'),
            )
            .toList();

    for (String path in jsonPaths) {
      print('Loading JSON from $path');
      try {
        final String jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        tempResponses.add(AasResponse.fromJson(jsonMap));
      } catch (e) {
        print('Error parsing $path: $e');
      }
    }

    responses = tempResponses;

    // Map process IDs to their corresponding Process objects
    processes =
        responses?.map((response) {
          return Process.fromJson(response);
        }).toList() ??
        [];
    List<Process> mocks = mockProcesses();
    processes.addAll(mocks);
    processMap = {for (var process in processes) process.id: process};
    print('ProcessMap initialized with ${processMap.length} entries');
  }

  static Process? getProcessById(String id) {
    return processMap[id];
  }

  static List<Process> getAllProcesses() {
    return processMap.values.toList();
  }

  static List<String> get processIds {
    return processMap.keys.toList();
  }

  static List<Process> mockProcesses() {
    return [
      Process(
        id: "LIQTRA FX-7 Pro Process",
        energyUsed: 1500.0,
        co2Emissions: 300.0,
        lastUpdated: DateTime.now(),
        type: 'CNC Machining',
        material: "R-PA12",
        manufacturer: 'IAPT',
        virginMaterial: 80.0,
        recycledMaterial: 20.0,
        imagePath: "assets/images/bauteil_image.png",
        progress: 75.5,
      ),
      Process(
        id: 'process_002',
        energyUsed: 2000.0,
        co2Emissions: 400.0,
        lastUpdated: DateTime.now(),
        type: '3D Printing',
        material: 'Plastic',
        manufacturer: 'PrintTech',
        virginMaterial: 70.0,
        recycledMaterial: 30.0,
        imagePath: "assets/images/bauteil_image3.png",
        progress: 92.3,
      ),
    ];
  }
}
