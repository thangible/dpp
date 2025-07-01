
import 'package:flutter/material.dart';
import 'package:dpp/config/theme/theme.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/divider.dart';

class ProductIdentifierCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String id;
  final DateTime lastUpdated;
  final String imagePath;
  final String material;
  final String productType;
  final String manufacturer;

  const ProductIdentifierCard({
    super.key,
    this.animationController,
    this.animation,
    required this.id,
    required this.lastUpdated,
    required this.imagePath,
    required this.material,
    required this.productType,
    required this.manufacturer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: buildCardTranslation(animation!.value),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: HeaderRow(
                              identifier: id,
                              lastUpdated: lastUpdated,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ImageSection(imagePath: imagePath),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: CustomDividerWidget(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: ProductInfoRow(
                        material: material,
                        productType: productType,
                        manufacturer: manufacturer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Matrix4 buildCardTranslation(double value) {
    final double translateY = 50 * (1.0 - value);
    return Matrix4.translationValues(0, translateY, 0);
  }
}

class HeaderRow extends StatelessWidget {
  final String identifier;
  final DateTime lastUpdated;

  const HeaderRow({
    super.key,
    required this.identifier,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            identifier,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.nearlyDarkBlue,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppTheme.grey.withOpacity(0.5),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Last updated: \n${_formatTime(context, lastUpdated)}',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 7,
                  color: AppTheme.grey.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${time.format(context)}';
  }
}


class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 150,
          height: 150,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


class ProductInfoRow extends StatelessWidget {
  final String material;
  final String productType;
  final String manufacturer;

  const ProductInfoRow({
    super.key,
    required this.material,
    required this.productType,
    required this.manufacturer,
  });

  Widget buildColumn(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: -0.2,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppTheme.grey.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: buildColumn(material, 'Material')),
        Expanded(child: buildColumn(productType, 'Product Type')),
        Expanded(child: buildColumn(manufacturer, 'Manufacturer')),
      ],
    );
  }
}
