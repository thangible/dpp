import 'package:flutter/material.dart';
import 'package:dpp/styles/app_theme.dart';
import 'dart:async';
import 'package:dpp/services/product_service.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onMachineSelected;

  const SearchBarWidget({Key? key, required this.onMachineSelected}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<String> machineIds = [];
  List<String> searchHistory = [];
  String? selectedMachineId;

  @override
  void initState() {
    super.initState();
    _loadMachineIds();
  }

  Future<void> _loadMachineIds() async {
    final ids = await ProductService.fetchMachineIds();
    setState(() {
      machineIds = ids;
    });
  }

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map(
      (String machineId) => ListTile(
        leading: const Icon(Icons.history, color: AppTheme.grey),
        title: Text(machineId, style: AppTheme.body1),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed, color: AppTheme.nearlyBlue),
          onPressed: () {
            controller.text = machineId;
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
        ),
      ),
    );
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text.toLowerCase();
    final filteredIds = machineIds.where((id) => id.toLowerCase().contains(input));
    return filteredIds.map(
      (String id) => ListTile(
        leading: const Icon(Icons.memory, color: AppTheme.nearlyBlue),
        title: Text(id, style: AppTheme.body1),
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

  void handleSelection(String machineId) {
    setState(() {
      selectedMachineId = machineId;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, machineId);
    });

    // ✅ Notify the parent using the callback
    widget.onMachineSelected(machineId);

    // Optionally fetch more data if needed
    // ProductService.fetchProductSummaryData(machineId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      colorSchemeSeed: selectedMachineId != null ? AppTheme.nearlyDarkBlue : AppTheme.nearlyDarkBlue,
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
                hintText: 'Search machine ID',
                leading: const Icon(Icons.search),
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
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              if (controller.text.isEmpty) {
                if (searchHistory.isNotEmpty) {
                  return getHistoryList(controller).toList();
                }
                return <Widget>[
                  Center(
                    child: Text(
                      'No search history.',
                      style: AppTheme.body1.copyWith(color: colors.outline),
                    ),
                  ),
                ];
              }
              return getSuggestions(controller).toList();
            },
          ),
        ),
      ],
    );
  }
}
