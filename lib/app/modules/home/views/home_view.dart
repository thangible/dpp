import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';
import 'package:dpp/app/routes/app_pages.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/material_service.dart';
import 'package:dpp/app/modules/footprint/views/product/product_detail.dart';
import 'package:dpp/app/modules/footprint/views/material/material_detail.dart';
import 'package:dpp/app/modules/scanner/views/scanner_screen.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'widgets/mode_pill.dart';
import 'widgets/recent_tile.dart';

/// The app's primary landing tab: a DHL-styled search home with a
/// Product/Material pill switcher up top and a "last searched" list
/// instead of DHL's shipment list — reusing HistoryController so it's the
/// same data the History tab shows.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HistoryItemType _mode = HistoryItemType.product;
  final _controller = TextEditingController();
  String? _error;
  List<String> _suggestions = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _idsForMode =>
      _mode == HistoryItemType.product
          ? ProductService.productIds
          : MaterialService.materialIds;

  void _onQueryChanged(String query) {
    setState(() {
      _error = null;
      _suggestions =
          query.isEmpty
              ? []
              : _idsForMode
                  .where((id) => id.toLowerCase().contains(query.toLowerCase()))
                  .take(5)
                  .toList();
    });
  }

  void _switchMode(HistoryItemType mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      _controller.clear();
      _suggestions = [];
      _error = null;
    });
  }

  void _search(String id) {
    if (id.trim().isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    if (_mode == HistoryItemType.product) {
      final product = ProductService.getProductById(id);
      if (product == null) {
        setState(() => _error = l10n.homeErrorProductNotFound(id));
        return;
      }
      _clearSearch();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      );
    } else {
      final material = MaterialService.getMaterialById(id);
      if (material == null) {
        setState(() => _error = l10n.homeErrorMaterialNotFound(id));
        return;
      }
      _clearSearch();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MaterialDetailScreen(material: material),
        ),
      );
    }
  }

  // Just clears the search field before navigating — history logging lives
  // on the destination screen itself (ProductDetailScreen/
  // MaterialDetailScreen) now, so every way of reaching it is covered in
  // one place instead of duplicated (and racing) at each call site.
  void _clearSearch() {
    setState(() {
      _controller.clear();
      _suggestions = [];
    });
  }

  void _openEntry(HistoryEntry entry) {
    if (entry.type == HistoryItemType.product) {
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
          builder: (context) => MaterialDetailScreen(materialId: entry.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colors, theme, l10n),
            Expanded(
              child: Obx(() => _buildBody(colors, theme, l10n)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // No hamburger to clear anymore (that moved into the More tab),
          // so the pills get the full width split evenly between them
          // instead of being pushed off-center to make room for it.
          Row(
            children: [
              Expanded(
                child: ModePill(
                  label: l10n.homeModeProduct,
                  selected: _mode == HistoryItemType.product,
                  onTap: () => _switchMode(HistoryItemType.product),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ModePill(
                  label: l10n.homeModeMaterial,
                  selected: _mode == HistoryItemType.material,
                  onTap: () => _switchMode(HistoryItemType.material),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: _onQueryChanged,
                  onSubmitted: _search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText:
                        _mode == HistoryItemType.product
                            ? l10n.homeSearchHintProduct
                            : l10n.homeSearchHintMaterial,
                    prefixIcon: const Icon(Icons.qr_code_scanner),
                    suffixIcon:
                        _controller.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                _onQueryChanged('');
                              },
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: colors.primary,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _search(_controller.text),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(Icons.search, color: colors.onPrimary),
                  ),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
            ),
          ],
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children:
                    _suggestions
                        .map(
                          (id) => ListTile(
                            dense: true,
                            leading: Icon(
                              _mode == HistoryItemType.product
                                  ? Icons.inventory_2_outlined
                                  : Icons.science_outlined,
                              color: colors.primary,
                            ),
                            title: Text(id),
                            onTap: () => _search(id),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colors, ThemeData theme, AppLocalizations l10n) {
    final history = Get.find<HistoryController>();
    final auth = Get.find<AuthController>();
    final recentForMode =
        history.recent.where((e) => e.type == _mode).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        if (recentForMode.isEmpty)
          _buildEmptyState(colors, theme, l10n)
        else ...[
          Text(l10n.homeLastSearched, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ...recentForMode.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RecentTile(
                entry: entry,
                onTap: () => _openEntry(entry),
              ),
            ),
          ),
        ],
        if (auth.isGuest.value) ...[
          const SizedBox(height: 20),
          _buildGuestCard(colors, theme, l10n),
        ],
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colors, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Icon(
            _mode == HistoryItemType.product
                ? Icons.inventory_2_outlined
                : Icons.science_outlined,
            size: 96,
            color: colors.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            _mode == HistoryItemType.product
                ? l10n.homeEmptyProductsTitle
                : l10n.homeEmptyMaterialsTitle,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.homeEmptyHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Get.to(() => const ScannerScreen()),
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.homeScanButton),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestCard(ColorScheme colors, ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: colors.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeGuestCardTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
                Text(
                  l10n.homeGuestCardBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await Get.find<AuthController>().signOut();
              Get.offAllNamed(Routes.SIGN_IN);
            },
            child: Text(l10n.profileSignIn),
          ),
        ],
      ),
    );
  }
}
