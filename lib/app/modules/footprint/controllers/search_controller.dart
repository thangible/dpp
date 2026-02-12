import 'package:dpp/app/data_model/hive/nameplate_hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/process_service.dart';

enum SearchType { product, process }

class SearchController extends GetxController {
  final textController = TextEditingController();
  var productIds = <String>[].obs;
  var processIds = <String>[].obs;
  var searchHistory = <String>[].obs;
  var filteredSuggestions = <String>[].obs;
  var query = ''.obs;
  var showSuggestions = false.obs;
  var searchType = SearchType.product.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _loadIds();
    print('SearchController initialized with search type: ${searchType.value}');
    // Update our query whenever the text field value changes.
    textController.addListener(() {
      query.value = textController.text;
    });
    // Whenever query changes, update suggestions.
    ever(query, (_) => _filterSuggestions());
    // Update suggestions when search type changes
    ever(searchType, (_) => _filterSuggestions());
  }

  Future<void> _initializeServices() async {
    await ProductService.init();
    await ProcessService.init();
  }

  Future<void> _loadIds() async {
    productIds.assignAll(ProductService.productIds);
    processIds.assignAll(ProcessService.processIds);
    print(
      "Loaded ${productIds.length} product IDs and ${processIds.length} process IDs.",
    );
  }

  List<String> get currentIds {
    switch (searchType.value) {
      case SearchType.product:
        return productIds;
      case SearchType.process:
        return processIds;
    }
  }

  void setSearchType(SearchType type) {
    searchType.value = type;
    textController.clear();
    query.value = '';
  }

  void _filterSuggestions() {
    if (query.value.isEmpty) {
      // Show search history filtered by current search type
      final historyForType =
          searchHistory.where((id) {
            switch (searchType.value) {
              case SearchType.product:
                return productIds.contains(id);
              case SearchType.process:
                return processIds.contains(id);
            }
          }).toList();
      filteredSuggestions.assignAll(historyForType);
    } else {
      filteredSuggestions.assignAll(
        currentIds.where(
          (id) => id.toLowerCase().contains(query.value.toLowerCase()),
        ),
      );
    }
  }

  void handleSelection(String selectedId) {
    textController.text = selectedId;
    showSuggestions.value = false;
    // Update search history.
    if (searchHistory.contains(selectedId)) {
      searchHistory.remove(selectedId);
    }
    if (searchHistory.length >= 10) {
      searchHistory.removeLast();
    }
    searchHistory.insert(0, selectedId);
  }

  String get searchTypeLabel {
    switch (searchType.value) {
      case SearchType.product:
        return 'Product';
      case SearchType.process:
        return 'Process';
    }
  }

  String get searchHint {
    switch (searchType.value) {
      case SearchType.product:
        return 'Search product ID';
      case SearchType.process:
        return 'Search process ID';
    }
  }

  IconData get searchIcon {
    switch (searchType.value) {
      case SearchType.product:
        return Icons.inventory_2;
      case SearchType.process:
        return Icons.precision_manufacturing;
    }
  }
}
