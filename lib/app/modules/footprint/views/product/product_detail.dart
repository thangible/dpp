import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:dpp/app/data/product.dart';
import 'package:dpp/app/services/test/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final AnimationController? animationController;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.animationController,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  Product? product;
  bool isLoading = true;
  String? error;

  Animation<double>? fadeAnimation;
  Animation<double>? slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProductData();
  }

  void _initializeAnimations() {
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    widget.animationController?.forward();
  }

  Future<void> _loadProductData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final productData = await ProductService.fetchProductData(
        widget.productId,
      );

      setState(() {
        if (productData != null) {
          product = productData;
          isLoading = false;
        } else {
          error = 'Product not found or data is null';
          isLoading = false;
        }
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load product data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.darkText),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Product Details',
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppTheme.darkText,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: AppTheme.darkText),
          onPressed: _loadProductData,
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingView();
    }

    if (error != null) {
      return _buildErrorView();
    }

    if (product == null) {
      return _buildEmptyView();
    }

    return _buildProductDetails();
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.nearlyDarkBlue),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading product details...',
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.grey),
          const SizedBox(height: 16),
          Text(
            'Error loading product details',
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error ?? 'Unknown error occurred',
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 14,
              color: AppTheme.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProductData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.nearlyDarkBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.grey),
          const SizedBox(height: 16),
          Text(
            'No product data available',
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation!,
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - slideAnimation!.value)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(),
                  const SizedBox(height: 24),
                  _buildProductImage(),
                  const SizedBox(height: 24),
                  _buildDetailsTables(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.inventory_2,
              color: AppTheme.nearlyDarkBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product ID: ${product?.id?.toString() ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last Updated: ${product?.lastUpdated != null ? _formatDateTime(product!.lastUpdated!) : 'N/A'}',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontSize: 14,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            (product?.imagePath?.isNotEmpty ?? false)
                ? Image.asset(
                  product!.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                )
                : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppTheme.grey.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 48, color: AppTheme.grey),
            const SizedBox(height: 8),
            Text(
              'No image available',
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTables() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Basic Information'),
        _buildDetailsTable(_getBasicInfoData()),
        const SizedBox(height: 24),
        _buildSectionTitle('Material Composition'),
        _buildDetailsTable(_getMaterialData()),
        const SizedBox(height: 24),
        _buildSectionTitle('Environmental Impact'),
        _buildDetailsTable(_getEnvironmentalData()),
        const SizedBox(height: 24),
        _buildSectionTitle('Additional Details'),
        _buildDetailsTable(_getAdditionalData()),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkText,
        ),
      ),
    );
  }

  Widget _buildDetailsTable(List<Map<String, String>> data) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            children: [
              _buildTableCell('Property', isHeader: true),
              _buildTableCell('Value', isHeader: true),
            ],
          ),
          // Data rows
          ...data.map(
            (row) => TableRow(
              children: [
                _buildTableCell(row['property']!),
                _buildTableCell(row['value']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontSize: isHeader ? 14 : 13,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
          color: isHeader ? AppTheme.nearlyDarkBlue : AppTheme.darkText,
        ),
      ),
    );
  }

  List<Map<String, String>> _getBasicInfoData() {
    if (product == null) return [];

    return [
      {'property': 'Product ID', 'value': product!.id?.toString() ?? 'N/A'},
      {'property': 'Type', 'value': product!.type ?? 'N/A'},
      {'property': 'Material', 'value': product!.material ?? 'N/A'},
      {'property': 'Manufacturer', 'value': product!.manufacturer ?? 'N/A'},
      {
        'property': 'Last Updated',
        'value':
            product!.lastUpdated != null
                ? _formatDateTime(product!.lastUpdated!)
                : 'N/A',
      },
    ];
  }

  List<Map<String, String>> _getMaterialData() {
    if (product == null) return [];

    return [
      {
        'property': 'Virgin Material',
        'value':
            '${((product!.virginMaterial ?? 0) * 100).toStringAsFixed(1)}%',
      },
      {
        'property': 'Recycled Material',
        'value':
            '${((product!.recycledMaterial ?? 0) * 100).toStringAsFixed(1)}%',
      },
      {
        'property': 'Total Material',
        'value':
            '${(((product!.virginMaterial ?? 0) + (product!.recycledMaterial ?? 0)) * 100).toStringAsFixed(1)}%',
      },
    ];
  }

  List<Map<String, String>> _getEnvironmentalData() {
    if (product == null) return [];

    final energyUsed = product!.energyUsed ?? 0;
    final co2Emissions = product!.co2Emissions ?? 0;

    return [
      {
        'property': 'Energy Used',
        'value': '${energyUsed.toStringAsFixed(2)} kWh',
      },
      {
        'property': 'CO2 Emissions',
        'value': '${co2Emissions.toStringAsFixed(2)} kg',
      },
      {
        'property': 'Carbon Footprint',
        'value':
            energyUsed > 0
                ? '${(co2Emissions / energyUsed).toStringAsFixed(3)} kg CO2/kWh'
                : 'N/A',
      },
    ];
  }

  List<Map<String, String>> _getAdditionalData() {
    if (product == null) return [];

    final virginMaterial = product!.virginMaterial ?? 0;
    final recycledMaterial = product!.recycledMaterial ?? 0;
    final totalMaterial = virginMaterial + recycledMaterial;

    return [
      {
        'property': 'Image Path',
        'value':
            (product!.imagePath?.isNotEmpty ?? false)
                ? product!.imagePath!
                : 'No image',
      },
      {
        'property': 'Sustainability Score',
        'value':
            totalMaterial > 0
                ? '${((recycledMaterial / totalMaterial) * 100).toStringAsFixed(1)}%'
                : 'N/A',
      },
      {
        'property': 'Energy Efficiency',
        'value': _getEnergyEfficiencyRating(product!.energyUsed ?? 0),
      },
    ];
  }

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
}
