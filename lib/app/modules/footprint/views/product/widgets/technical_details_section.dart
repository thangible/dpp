import 'package:flutter/material.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/app/modules/footprint/views/product/product_ratings.dart';
import 'section_card.dart';
import 'metric_card.dart';

/// Flat ID/type/material/manufacturer table, plus the two derived scores
/// (sustainability %, legacy per-kWh carbon figure).
class TechnicalDetailsSection extends StatelessWidget {
  const TechnicalDetailsSection({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SectionCard(
      title: l10n.productTechnicalDetails,
      icon: Icons.settings,
      iconColor: colors.onSurfaceVariant,
      child: Column(
        children: [
          DetailRow(
            label: l10n.productIdLabel,
            value: product?.id.toString() ?? l10n.commonNA,
            labelWidth: 140,
          ),
          DetailRow(
            label: l10n.productTypeLabel,
            value: product?.type ?? l10n.commonNA,
            labelWidth: 140,
          ),
          DetailRow(
            label: l10n.productMaterialLabel,
            value: product?.material ?? l10n.commonNA,
            labelWidth: 140,
          ),
          DetailRow(
            label: l10n.productManufacturer,
            value: product?.manufacturer ?? l10n.commonNA,
            labelWidth: 140,
          ),
          DetailRow(
            label: l10n.productSustainabilityScore,
            value: sustainabilityScore(
              l10n,
              virginMaterial: product?.virginMaterial,
              recycledMaterial: product?.recycledMaterial,
            ),
            labelWidth: 140,
          ),
          DetailRow(
            label: l10n.productCarbonFootprintRow,
            value: legacyCarbonFootprint(
              l10n,
              energyUsed: product?.energyUsed,
              co2Emissions: product?.co2Emissions,
            ),
            labelWidth: 140,
          ),
        ],
      ),
    );
  }
}
