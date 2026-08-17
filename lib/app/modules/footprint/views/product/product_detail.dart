import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/material_service.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/config/utils/motion.dart';
import 'widgets/product_overview_card.dart';
import 'widgets/material_link_card.dart';
import 'widgets/carbon_footprint_section.dart';
import 'widgets/quick_actions_card.dart';
import 'widgets/product_image_card.dart';
import 'widgets/environmental_metrics_section.dart';
import 'widgets/material_composition_section.dart';
import 'widgets/technical_details_section.dart';

/// Product passport screen. Owns loading/error state and the entrance
/// animation; everything visual is one of the section widgets under
/// widgets/, composed together in [_buildContentSliver] below.
class ProductDetailScreen extends StatefulWidget {
  final Product? product;
  final String? productId;
  final AnimationController? animationController;

  const ProductDetailScreen({
    super.key,
    this.product,
    this.productId,
    this.animationController,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

enum _ProductError { noInfo, notFound, loadFailed }

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  Product? product;
  bool isLoading = false;
  // Stored as a code + raw detail (not a translated string) because the
  // error can be set from initState(), before AppLocalizations.of(context)
  // is safe to call — it's translated lazily in _buildErrorSliver instead.
  _ProductError? errorType;
  String? errorDetail;

  bool get _hasError => errorType != null;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  ColorScheme get _colors => Theme.of(context).colorScheme;
  TextTheme get _text => Theme.of(context).textTheme;
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  model.Material? get _material {
    final materialId = product?.materialId;
    if (materialId == null) return null;
    return MaterialService.getMaterialById(materialId);
  }

  // ---- Lifecycle ---------------------------------------------------

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeProductData();
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  // ---- Data loading --------------------------------------------------

  void _initializeProductData() {
    if (widget.product != null) {
      // Product data provided directly
      product = widget.product;
      isLoading = false;
      _logHistory();
    } else if (widget.productId != null) {
      // Load product data by ID
      _loadProductData();
    } else {
      // No product or productId provided
      errorType = _ProductError.noInfo;
      isLoading = false;
    }
  }

  Future<void> _loadProductData() async {
    try {
      setState(() {
        isLoading = true;
        errorType = null;
      });

      final productData = ProductService.getProductById(
        widget.productId ?? product?.id.toString() ?? '',
      );

      if (!mounted) return;

      setState(() {
        if (productData != null) {
          product = productData;
          isLoading = false;
          _logHistory();
        } else {
          errorType = _ProductError.notFound;
          errorDetail = widget.productId ?? product?.id.toString();
          isLoading = false;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorType = _ProductError.loadFailed;
        errorDetail = e.toString();
        isLoading = false;
      });
    }
  }

  // Log to history regardless of how we got here (Home search, scanner, or
  // tapping a History entry) so "last viewed" on Home reflects every real
  // way a product gets looked at, and re-viewing bumps its recency.
  // Deferred a frame: this fires from initState/setState while this screen's
  // own route is still being built, and mutating the shared HistoryController
  // synchronously there trips "setState() or markNeedsBuild() called during
  // build" for the Home screen's Obx sitting underneath.
  void _logHistory() {
    final id = product?.id;
    if (id == null || !Get.isRegistered<HistoryController>()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HistoryController>().addEntry(id, HistoryItemType.product);
    });
  }

  String get _productId =>
      widget.productId ?? product?.id.toString() ?? 'Unknown';

  // ---- Animations ------------------------------------------------------

  void _initializeAnimations() {
    _animationController =
        widget.animationController ??
        AnimationController(
          duration: const Duration(milliseconds: 1200),
          vsync: this,
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: AppMotion.enter),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: AppMotion.enter),
      ),
    );

    // Plain ease-out, not easeOutBack — no overshoot/bounce, just a smooth
    // settle, matching the rest of the app's motion.
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: AppMotion.enter),
      ),
    );

    _animationController.forward();
  }

  // ---- Build -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          if (isLoading) _buildLoadingSliver(),
          if (_hasError) _buildErrorSliver(),
          if (product != null) _buildContentSliver(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      floating: false,
      backgroundColor: _colors.surface,
      foregroundColor: _colors.onSurface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(_l10n.productDetailsTitle, style: _text.titleLarge),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _colors.primary.withValues(alpha: 0.1),
                _colors.surface,
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (product != null)
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => showProductQrDialog(context, _productId),
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadProductData,
        ),
      ],
    );
  }

  Widget _buildLoadingSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _colors.primary),
            const SizedBox(height: 24),
            Text(
              _l10n.productLoading,
              style: _text.bodyLarge?.copyWith(color: _colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: _colors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 24),
              Text(
                _l10n.productNotFoundTitle,
                style: _text.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage(),
                style: _text.bodyMedium?.copyWith(
                  color: _colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _loadProductData,
                icon: const Icon(Icons.refresh),
                label: Text(_l10n.productTryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: RefreshIndicator(
                  onRefresh: _loadProductData,
                  color: _colors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductOverviewCard(product: product),
                        const SizedBox(height: 24),
                        MaterialLinkCard(product: product, material: _material),
                        const SizedBox(height: 24),
                        QuickActionsCard(productId: _productId),
                        const SizedBox(height: 24),
                        ProductImageCard(imagePath: product?.imagePath),
                        const SizedBox(height: 24),
                        CarbonFootprintSection(
                          product: product,
                          material: _material,
                        ),
                        const SizedBox(height: 24),
                        EnvironmentalMetricsSection(product: product),
                        const SizedBox(height: 24),
                        MaterialCompositionSection(product: product),
                        const SizedBox(height: 24),
                        TechnicalDetailsSection(product: product),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _errorMessage() {
    switch (errorType) {
      case _ProductError.noInfo:
        return _l10n.commonNoInfoProvided;
      case _ProductError.notFound:
        return _l10n.productErrorNotFoundBody(errorDetail ?? '');
      case _ProductError.loadFailed:
        return _l10n.productErrorLoadFailed(errorDetail ?? '');
      case null:
        return _l10n.productErrorUnknown;
    }
  }
}
