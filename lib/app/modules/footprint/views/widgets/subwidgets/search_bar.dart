import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'dart:async';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/process_service.dart';

enum SearchBarType { product, process }

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onItemSelected;
  final SearchBarType searchType;

  const SearchBarWidget({
    Key? key,
    required this.onItemSelected,
    this.searchType = SearchBarType.product,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<String> productIds = [];
  List<String> processIds = [];
  List<String> searchHistory = [];
  String? selectedId;

  @override
  void initState() {
    super.initState();
    _loadIds();
    print("SearchBar initialized with search type: ${widget.searchType}");
  }

  Future<void> _loadIds() async {
    // await ProductService.init();
    // await ProcessService.init();
    setState(() {
      productIds = ProductService.productIds;
      processIds = ProcessService.processIds;
    });
    print(
      "Loaded ${productIds.length} product IDs and ${processIds.length} process IDs.",
    );
    print("Current search type: ${widget.searchType}");
  }

  List<String> get currentIds {
    switch (widget.searchType) {
      case SearchBarType.product:
        return productIds;
      case SearchBarType.process:
        return processIds;
    }
  }

  String get searchHint {
    switch (widget.searchType) {
      case SearchBarType.product:
        return 'Search product ID';
      case SearchBarType.process:
        return 'Search process ID';
    }
  }

  IconData get searchIcon {
    switch (widget.searchType) {
      case SearchBarType.product:
        return Icons.inventory_2;
      case SearchBarType.process:
        return Icons.precision_manufacturing;
    }
  }

  Iterable<Widget> getHistoryList(SearchController controller) {
    // Filter history by current search type
    final historyForType =
        searchHistory.where((id) {
          return currentIds.contains(id);
        }).toList();

    return historyForType.map(
      (String id) => ListTile(
        leading: Icon(Icons.history, color: AppTheme.grey),
        title: Text(id, style: AppTheme.body1),
        subtitle: Text(
          widget.searchType == SearchBarType.product ? 'Product' : 'Process',
          style: TextStyle(fontSize: 12, color: AppTheme.grey.withOpacity(0.7)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed, color: AppTheme.nearlyBlue),
          onPressed: () {
            controller.text = id;
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
        ),
        onTap: () {
          controller.closeView(id);
          handleSelection(id);
        },
      ),
    );
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text.toLowerCase();
    final filteredIds = currentIds.where(
      (id) => id.toLowerCase().contains(input),
    );

    return filteredIds.map(
      (String id) => ListTile(
        leading: Icon(searchIcon, color: AppTheme.nearlyBlue),
        title: Text(id, style: AppTheme.body1),
        subtitle: Text(
          widget.searchType == SearchBarType.product
              ? 'Product ID'
              : 'Process ID',
          style: TextStyle(fontSize: 12, color: AppTheme.grey.withOpacity(0.7)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed, color: AppTheme.nearlyBlue),
          onPressed: () {
            controller.text = id;
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
        ),
        onTap: () {
          controller.closeView(id);
          handleSelection(id);
        },
      ),
    );
  }

  void handleSelection(String selectedId) {
    setState(() {
      selectedId = selectedId;
      // Update search history
      if (searchHistory.contains(selectedId)) {
        searchHistory.remove(selectedId);
      }
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, selectedId);
    });

    // Notify the parent using the callback
    widget.onItemSelected(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      colorSchemeSeed: AppTheme.nearlyDarkBlue,
      scaffoldBackgroundColor: AppTheme.background,
    );
    final ColorScheme colors = themeData.colorScheme;

    return Column(
      children: <Widget>[
        Material(
          type: MaterialType.transparency,
          elevation: 0,
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                elevation: const WidgetStatePropertyAll<double>(0),
                hintText: searchHint,
                leading: Icon(searchIcon),
                backgroundColor: WidgetStateProperty.all(AppTheme.nearlyWhite),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.1,
                    color: AppTheme.grey,
                  ),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (
              BuildContext context,
              SearchController controller,
            ) {
              if (controller.text.isEmpty) {
                final historyList = getHistoryList(controller).toList();
                if (historyList.isNotEmpty) {
                  return [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Recent ${widget.searchType == SearchBarType.product ? 'Products' : 'Processes'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    ...historyList,
                  ];
                }
                return <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(searchIcon, size: 48, color: colors.outline),
                          const SizedBox(height: 8),
                          Text(
                            'No search history for ${widget.searchType == SearchBarType.product ? 'products' : 'processes'}.',
                            style: AppTheme.body1.copyWith(
                              color: colors.outline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              }

              final suggestions = getSuggestions(controller).toList();
              if (suggestions.isEmpty) {
                return <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No ${widget.searchType == SearchBarType.product ? 'products' : 'processes'} found.',
                        style: AppTheme.body1.copyWith(color: colors.outline),
                      ),
                    ),
                  ),
                ];
              }

              return [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${suggestions.length} ${widget.searchType == SearchBarType.product ? 'Product' : 'Process'} Results',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
                ...suggestions,
              ];
            },
          ),
        ),
      ],
    );
  }
}
