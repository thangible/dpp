import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:dpp/app/modules/home/controllers/search_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onMachineSelected;

  const SearchBarWidget({Key? key, required this.onMachineSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create/get the SearchController instance.
    final searchController = Get.put(SearchController());
    return Column(
      children: [
        TextField(
          controller: searchController.textController,
          onTap: () => searchController.showSuggestions.value = true,
          decoration: InputDecoration(
            hintText: 'Search machine ID',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: AppTheme.nearlyWhite,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: -0.1,
            color: AppTheme.grey,
          ),
        ),
        Obx(() {
          if (!searchController.showSuggestions.value) return Container();
          final suggestions = searchController.query.value.isEmpty
              ? searchController.searchHistory
              : searchController.filteredSuggestions;
          if (suggestions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No suggestions available.',
                  style: AppTheme.body1.copyWith(
                      color: Theme.of(context).colorScheme.outline),
                ),
              ),
            );
          }
          return Container(
            constraints: const BoxConstraints(maxHeight: 250),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppTheme.nearlyWhite,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final id = suggestions[index];
                return ListTile(
                  leading: Icon(
                    searchController.query.value.isEmpty
                        ? Icons.history
                        : Icons.memory,
                    color: searchController.query.value.isEmpty
                        ? AppTheme.grey
                        : AppTheme.nearlyBlue,
                  ),
                  title: Text(id, style: AppTheme.body1),
                  onTap: () {
                    searchController.handleSelection(id);
                    onMachineSelected(id);
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}