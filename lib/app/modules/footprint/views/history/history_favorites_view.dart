import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';
import 'package:dpp/app/modules/footprint/views/product/product_detail.dart';
import 'package:dpp/app/modules/footprint/views/process/process_detail.dart';

class HistoryFavoritesScreen extends StatefulWidget {
  const HistoryFavoritesScreen({super.key});

  @override
  State<HistoryFavoritesScreen> createState() =>
      _HistoryFavoritesScreenState();
}

class _HistoryFavoritesScreenState extends State<HistoryFavoritesScreen> {
  bool _showAllFavorites = false;
  bool _showAllRecent = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = Get.find<HistoryController>();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 20, top: 16),
              child: Text('History & Favorites', style: theme.textTheme.headlineSmall),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Obx(
                () => ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    _Section(
                      title: 'Favorites',
                      emptyText:
                          'Nothing favorited yet. Tap the star on any item to save it here.',
                      entries: controller.favorites,
                      showAll: _showAllFavorites,
                      onToggleShowAll:
                          () => setState(
                            () => _showAllFavorites = !_showAllFavorites,
                          ),
                      colors: colors,
                      theme: theme,
                    ),
                    const SizedBox(height: 28),
                    _Section(
                      title: 'Recent',
                      emptyText:
                          'No history yet. Search or scan a product/process to see it here.',
                      entries: controller.recent,
                      showAll: _showAllRecent,
                      onToggleShowAll:
                          () => setState(
                            () => _showAllRecent = !_showAllRecent,
                          ),
                      colors: colors,
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  static const int previewCount = 3;

  final String title;
  final String emptyText;
  final List<HistoryEntry> entries;
  final bool showAll;
  final VoidCallback onToggleShowAll;
  final ColorScheme colors;
  final ThemeData theme;

  const _Section({
    required this.title,
    required this.emptyText,
    required this.entries,
    required this.showAll,
    required this.onToggleShowAll,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final visible = showAll ? entries : entries.take(previewCount).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            if (entries.length > previewCount)
              TextButton(
                onPressed: onToggleShowAll,
                child: Text(showAll ? 'Show less' : 'See all (${entries.length})'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emptyText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          )
        else
          ...visible.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _HistoryTile(entry: entry, colors: colors, theme: theme),
            ),
          ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final HistoryEntry entry;
  final ColorScheme colors;
  final ThemeData theme;

  const _HistoryTile({
    required this.entry,
    required this.colors,
    required this.theme,
  });

  bool get _isProduct => entry.type == HistoryItemType.product;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _isProduct ? Icons.inventory_2 : Icons.precision_manufacturing,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.id,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_isProduct ? 'Product' : 'Process'} · ${_relativeTime(entry.viewedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  entry.isFavorite ? Icons.star : Icons.star_border,
                  color: entry.isFavorite ? colors.secondary : colors.onSurfaceVariant,
                ),
                onPressed:
                    () => Get.find<HistoryController>().toggleFavorite(
                      entry.id,
                      entry.type,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    if (_isProduct) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(productId: entry.id),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessDetailScreen(processId: entry.id),
        ),
      );
    }
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
