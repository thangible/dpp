import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/process_service.dart';

enum SearchBarType { product, process }

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onItemSelected;
  final SearchBarType searchType;

  const SearchBarWidget({
    super.key,
    required this.onItemSelected,
    this.searchType = SearchBarType.product,
  });

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
  }

  Future<void> _loadIds() async {
    setState(() {
      productIds = ProductService.productIds;
      processIds = ProcessService.processIds;
    });
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

  Iterable<Widget> getHistoryList(SearchController controller, ColorScheme colors) {
    // Filter history by current search type
    final historyForType =
        searchHistory.where((id) {
          return currentIds.contains(id);
        }).toList();

    return historyForType.map(
      (String id) => ListTile(
        leading: Icon(Icons.history, color: colors.onSurfaceVariant),
        title: Text(id),
        subtitle: Text(
          widget.searchType == SearchBarType.product ? 'Product' : 'Process',
        ),
        trailing: IconButton(
          icon: Icon(Icons.call_missed, color: colors.primary),
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

  Iterable<Widget> getSuggestions(SearchController controller, ColorScheme colors) {
    final String input = controller.value.text.toLowerCase();
    final filteredIds = currentIds.where(
      (id) => id.toLowerCase().contains(input),
    );

    return filteredIds.map(
      (String id) => ListTile(
        leading: Icon(searchIcon, color: colors.primary),
        title: Text(id),
        subtitle: Text(
          widget.searchType == SearchBarType.product
              ? 'Product ID'
              : 'Process ID',
        ),
        trailing: IconButton(
          icon: Icon(Icons.call_missed, color: colors.primary),
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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                backgroundColor: WidgetStateProperty.all(
                  colors.surfaceContainerHighest,
                ),
                textStyle: WidgetStateProperty.all(
                  textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
                onTap: () {
                  // Re-opening a bar that already has a query (e.g.
                  // searching a second time) should select the existing
                  // text so typing replaces it cleanly, instead of
                  // inserting at wherever the cursor happens to land.
                  if (controller.text.isNotEmpty) {
                    controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.text.length,
                    );
                  }
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
                final historyList = getHistoryList(controller, colors).toList();
                if (historyList.isNotEmpty) {
                  return [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Recent ${widget.searchType == SearchBarType.product ? 'Products' : 'Processes'}',
                        style: textTheme.labelLarge?.copyWith(
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
                            style: textTheme.bodyLarge?.copyWith(
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

              final suggestions = getSuggestions(controller, colors).toList();
              if (suggestions.isEmpty) {
                return <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No ${widget.searchType == SearchBarType.product ? 'products' : 'processes'} found.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.outline,
                        ),
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
                    style: textTheme.labelLarge?.copyWith(color: colors.primary),
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
