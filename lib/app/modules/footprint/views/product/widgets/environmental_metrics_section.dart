import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/app/modules/footprint/views/product/product_ratings.dart';
import 'section_card.dart';
import 'metric_card.dart';

/// Energy used during the manufacturing process, with an efficiency rating.
class EnvironmentalMetricsSection extends StatelessWidget {
  const EnvironmentalMetricsSection({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context)!;
    final energyUsed = product?.energyUsed ?? 0;

    return SectionCard(
      title: l10n.productEnvironmentalImpact,
      icon: Icons.eco,
      iconColor: semantic.success,
      child: MetricCard(
        title: l10n.productEnergyUsed,
        value: '${energyUsed.toStringAsFixed(2)} kWh',
        icon: Icons.bolt,
        color: semantic.warning,
        subtitle: energyEfficiencyRating(l10n, energyUsed),
      ),
    );
  }
}
