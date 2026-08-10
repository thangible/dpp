import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  Product? product;
  bool isLoading = false;
  String? error;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  ColorScheme get _colors => Theme.of(context).colorScheme;
  TextTheme get _text => Theme.of(context).textTheme;
  AppSemanticColors get _semantic => context.semanticColors;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeProductData();
  }

  void _initializeProductData() {
    if (widget.product != null) {
      // Product data provided directly
      product = widget.product;
      isLoading = false;
    } else if (widget.productId != null) {
      // Load product data by ID
      _loadProductData();
    } else {
      // No product or productId provided
      error = 'No product information provided';
      isLoading = false;
    }
  }

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
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _loadProductData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final productData = ProductService.getProductById(
        widget.productId ?? product?.id.toString() ?? '',
      );

      if (!mounted) return;

      setState(() {
        if (productData != null) {
          product = productData;
          isLoading = false;
        } else {
          error = 'Product not found (ID: ${widget.productId ?? product?.id})';
          isLoading = false;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Failed to load product: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  String get _productId =>
      widget.productId ?? product?.id.toString() ?? 'Unknown';

  @override
  void dispose() {
    if (widget.animationController == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          if (isLoading) _buildLoadingSliver(),
          if (error != null) _buildErrorSliver(),
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
        title: Text('Product Details', style: _text.titleLarge),
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
          IconButton(icon: const Icon(Icons.qr_code), onPressed: _showQRDialog),
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
              'Loading product details...',
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
                'Oops! Something went wrong',
                style: _text.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error ?? 'Unknown error occurred',
                style: _text.bodyMedium?.copyWith(
                  color: _colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _loadProductData,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
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
                        _buildProductOverview(),
                        const SizedBox(height: 24),
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        _buildProductImage(),
                        const SizedBox(height: 24),
                        _buildEnvironmentalMetrics(),
                        const SizedBox(height: 24),
                        _buildMaterialComposition(),
                        const SizedBox(height: 24),
                        _buildTechnicalDetails(),
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: _colors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: _colors.shadow.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildProductOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: _colors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.id.toString() ?? 'N/A',
                      style: _text.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product?.type ?? 'Unknown Type',
                      style: _text.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Manufacturer', product?.manufacturer ?? 'N/A'),
          _buildInfoRow('Material', product?.material ?? 'N/A'),
          _buildInfoRow(
            'Last Updated',
            product?.lastUpdated != null
                ? _formatDateTime(product!.lastUpdated!)
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: _text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: _colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: _text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: _text.titleLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.qr_code,
                label: 'QR Code',
                color: _colors.primary,
                onPressed: _showQRDialog,
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                color: _semantic.success,
                onPressed: _shareProduct,
              ),
              _buildActionButton(
                icon: Icons.download,
                label: 'Export',
                color: _semantic.warning,
                onPressed: _exportData,
              ),
              _buildActionButton(
                icon: Icons.analytics,
                label: 'Analytics',
                color: _semantic.info,
                onPressed: _showAnalytics,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: _text.labelMedium?.copyWith(color: _colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            (product?.imagePath?.isNotEmpty ?? false)
                ? Image.asset(
                  product!.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => _buildImagePlaceholder(),
                )
                : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _colors.onSurfaceVariant.withValues(alpha: 0.1),
            _colors.primary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 64,
              color: _colors.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'No image available',
              style: _text.bodyLarge?.copyWith(color: _colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalMetrics() {
    return _buildSection(
      title: 'Environmental Impact',
      icon: Icons.eco,
      iconColor: _semantic.success,
      child: Column(
        children: [
          _buildMetricCard(
            title: 'Energy Used',
            value: '${(product?.energyUsed ?? 0).toStringAsFixed(2)} kWh',
            icon: Icons.bolt,
            color: _semantic.warning,
            subtitle: _getEnergyEfficiencyRating(product?.energyUsed ?? 0),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            title: 'CO2 Emissions',
            value: '${(product?.co2Emissions ?? 0).toStringAsFixed(2)} kg',
            icon: Icons.cloud,
            color: _colors.error,
            subtitle: _getCO2Rating(product?.co2Emissions ?? 0),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialComposition() {
    final virginMaterial = product?.virginMaterial ?? 0;
    final recycledMaterial = product?.recycledMaterial ?? 0;
    final totalMaterial = virginMaterial + recycledMaterial;
    final isMostlyRecycled =
        totalMaterial > 0 && recycledMaterial / totalMaterial > 0.5;

    return _buildSection(
      title: 'Material Composition',
      icon: Icons.layers,
      iconColor: _colors.primary,
      child: Column(
        children: [
          _buildProgressCard(
            title: 'Recycled Material',
            percentage: recycledMaterial * 100,
            color: _semantic.success,
          ),
          const SizedBox(height: 12),
          _buildProgressCard(
            title: 'Virgin Material',
            percentage: virginMaterial * 100,
            color: _semantic.warning,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isMostlyRecycled ? _semantic.success : _semantic.warning)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isMostlyRecycled ? Icons.eco : Icons.warning,
                  color: isMostlyRecycled ? _semantic.success : _semantic.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isMostlyRecycled
                        ? 'Eco-friendly: High recycled content'
                        : 'Consider using more recycled materials',
                    style: _text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalDetails() {
    return _buildSection(
      title: 'Technical Details',
      icon: Icons.settings,
      iconColor: _colors.onSurfaceVariant,
      child: Column(
        children: [
          _buildDetailRow('Product ID', product?.id.toString() ?? 'N/A'),
          _buildDetailRow('Type', product?.type ?? 'N/A'),
          _buildDetailRow('Material', product?.material ?? 'N/A'),
          _buildDetailRow('Manufacturer', product?.manufacturer ?? 'N/A'),
          _buildDetailRow('Sustainability Score', _getSustainabilityScore()),
          _buildDetailRow('Carbon Footprint', _getCarbonFootprint()),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(title, style: _text.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _text.bodyMedium?.copyWith(
                    color: _colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: _text.titleLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: _text.labelMedium?.copyWith(color: color),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: _text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: _text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: _colors.onSurfaceVariant.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: _text.bodyMedium?.copyWith(
                color: _colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: _text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _showQRDialog() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Product QR Code', style: _text.titleLarge),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _colors.outlineVariant,
                      ),
                    ),
                    child: QrImageView(
                      data: _productId,
                      version: QrVersions.auto,
                      size: 180,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ID: $_productId',
                    style: _text.bodyMedium?.copyWith(
                      color: _colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _shareProduct() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Share feature coming soon!')));
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon!')),
    );
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analytics feature coming soon!')),
    );
  }

  // Helper methods
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getEnergyEfficiencyRating(double energyUsed) {
    if (energyUsed < 50) return 'A+ (Excellent)';
    if (energyUsed < 100) return 'A (Very Good)';
    if (energyUsed < 150) return 'B (Good)';
    if (energyUsed < 200) return 'C (Average)';
    if (energyUsed < 300) return 'D (Below Average)';
    return 'E (Poor)';
  }

  String _getCO2Rating(double co2Emissions) {
    if (co2Emissions < 10) return 'Low Impact';
    if (co2Emissions < 25) return 'Moderate Impact';
    if (co2Emissions < 50) return 'High Impact';
    return 'Very High Impact';
  }

  String _getSustainabilityScore() {
    if (product == null) return 'N/A';

    final virginMaterial = product!.virginMaterial ?? 0;
    final recycledMaterial = product!.recycledMaterial ?? 0;
    final totalMaterial = virginMaterial + recycledMaterial;

    if (totalMaterial <= 0) return 'N/A';

    final score = (recycledMaterial / totalMaterial) * 100;
    return '${score.toStringAsFixed(1)}% Sustainable';
  }

  String _getCarbonFootprint() {
    if (product == null) return 'N/A';

    final energyUsed = product!.energyUsed ?? 0;
    final co2Emissions = product!.co2Emissions ?? 0;

    if (energyUsed <= 0) return 'N/A';

    final footprint = co2Emissions / energyUsed;
    return '${footprint.toStringAsFixed(3)} kg CO2/kWh';
  }
}
