import 'package:flutter/material.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/app/modules/footprint/views/product/product_ratings.dart';
import 'section_card.dart';
import 'metric_card.dart';

/// The header card: icon, ID, type, and the manufacturer/material/updated
/// summary rows.
class ProductOverviewCard extends StatelessWidget {
  const ProductOverviewCard({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: colors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.id.toString() ?? l10n.commonNA,
                      style: text.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product?.type ?? l10n.productUnknownType,
                      style: text.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DetailRow(
            label: l10n.productManufacturer,
            value: product?.manufacturer ?? l10n.commonNA,
          ),
          DetailRow(
            label: l10n.productMaterialLabel,
            value: product?.material ?? l10n.commonNA,
          ),
          DetailRow(
            label: l10n.productLastUpdated,
            value:
                product?.lastUpdated != null
                    ? formatDateTime(product!.lastUpdated!)
                    : l10n.commonNA,
          ),
        ],
      ),
    );
  }
}
