import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'dart:async';
import 'package:dpp/app/services/product_service.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onMachineSelected;

  const SearchBarWidget({Key? key, required this.onMachineSelected}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> machineIds = [];
  List<String> searchHistory = [];
  List<String> filteredSuggestions = [];
  bool showSuggestions = false;
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

  void _onTextChanged(String input) {
    setState(() {
      showSuggestions = true;
      filteredSuggestions = machineIds
          .where((id) => id.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  void handleSelection(String machineId) {
    setState(() {
      selectedMachineId = machineId;
      _controller.text = machineId;
      showSuggestions = false;

      if (searchHistory.contains(machineId)) {
        searchHistory.remove(machineId);
      }
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, machineId);
    });

    widget.onMachineSelected(machineId);
  }

  Widget _buildSuggestionList() {
    final suggestions = _controller.text.isEmpty ? searchHistory : filteredSuggestions;

    if (suggestions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No suggestions available.',
            style: AppTheme.body1.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final id = suggestions[index];
        return ListTile(
          leading: Icon(
            _controller.text.isEmpty ? Icons.history : Icons.memory,
            color: _controller.text.isEmpty ? AppTheme.grey : AppTheme.nearlyBlue,
          ),
          title: Text(id, style: AppTheme.body1),
          onTap: () => handleSelection(id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _onTextChanged,
          onTap: () => setState(() => showSuggestions = true),
          decoration: InputDecoration(
            hintText: 'Search machine ID',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: AppTheme.nearlyWhite,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
        if (showSuggestions)
          Container(
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
            child: _buildSuggestionList(),
          ),
      ],
    );
  }
}
