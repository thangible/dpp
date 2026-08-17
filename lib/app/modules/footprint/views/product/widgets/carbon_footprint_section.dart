import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/app/modules/footprint/views/product/product_ratings.dart';
import 'section_card.dart';
import 'metric_card.dart';

/// CO2 from the manufacturing process, CO2 from the material itself, and an
/// indicative total. See [AppLocalizations.productCo2TotalNote] for why the
/// total is a simplified sum rather than a unit-normalized LCA figure.
class CarbonFootprintSection extends StatelessWidget {
  const CarbonFootprintSection({
    super.key,
    required this.product,
    required this.material,
  });

  final Product? product;
  final model.Material? material;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context)!;

    final processCo2 = product?.co2Emissions;
    final materialCo2 = material?.co2FootprintPerKg;
    final total = (processCo2 ?? 0) + (materialCo2 ?? 0);

    return SectionCard(
      title: l10n.productCarbonFootprint,
      icon: Icons.co2_outlined,
      iconColor: colors.error,
      child: Column(
        children: [
          MetricCard(
            title: l10n.productCo2Process,
            value:
                processCo2 != null
                    ? '${processCo2.toStringAsFixed(2)} kg'
                    : l10n.commonNA,
            icon: Icons.precision_manufacturing_outlined,
            color: semantic.warning,
            subtitle:
                processCo2 != null ? co2Rating(l10n, processCo2) : null,
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: l10n.productCo2Material,
            value:
                materialCo2 != null
                    ? '$materialCo2 kg CO2e/kg'
                    : l10n.commonNA,
            icon: Icons.science_outlined,
            color: colors.secondary,
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: l10n.productCo2Total,
            value:
                (processCo2 != null || materialCo2 != null)
                    ? '${total.toStringAsFixed(2)} kg CO2e'
                    : l10n.commonNA,
            icon: Icons.summarize_outlined,
            color: colors.error,
            subtitle: l10n.productCo2TotalNote,
          ),
        ],
      ),
    );
  }
}
