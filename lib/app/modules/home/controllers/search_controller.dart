import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/services/product_service.dart';

class SearchController extends GetxController {
  final textController = TextEditingController();
  var machineIds = <String>[].obs;
  var searchHistory = <String>[].obs;
  var filteredSuggestions = <String>[].obs;
  var query = ''.obs;
  var showSuggestions = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMachineIds();
    // Update our query whenever the text field value changes.
    textController.addListener(() {
      query.value = textController.text;
    });
    // Whenever query changes, update suggestions.
    ever(query, (_) => _filterSuggestions());
  }

  Future<void> _loadMachineIds() async {
    final ids = await ProductService.fetchMachineIds();
    machineIds.assignAll(ids);
  }

  void _filterSuggestions() {
    if (query.value.isEmpty) {
      filteredSuggestions.assignAll(searchHistory);
    } else {
      filteredSuggestions.assignAll(
        machineIds.where((id) =>
            id.toLowerCase().contains(query.value.toLowerCase())),
      );
    }
  }

  void handleSelection(String machineId) {
    textController.text = machineId;
    showSuggestions.value = false;
    // Update search history.
    if (searchHistory.contains(machineId)) {
      searchHistory.remove(machineId);
    }
    if (searchHistory.length >= 5) {
      searchHistory.removeLast();
    }
    searchHistory.insert(0, machineId);
  }
}