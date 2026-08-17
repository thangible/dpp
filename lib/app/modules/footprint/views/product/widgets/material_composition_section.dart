import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'section_card.dart';
import 'metric_card.dart';

/// Recycled vs. virgin material share, as two progress bars plus a callout
/// encouraging more recycled content when it's under half.
class MaterialCompositionSection extends StatelessWidget {
  const MaterialCompositionSection({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context)!;

    final virginMaterial = product?.virginMaterial ?? 0;
    final recycledMaterial = product?.recycledMaterial ?? 0;
    final totalMaterial = virginMaterial + recycledMaterial;
    final isMostlyRecycled =
        totalMaterial > 0 && recycledMaterial / totalMaterial > 0.5;

    return SectionCard(
      title: l10n.productMaterialComposition,
      icon: Icons.layers,
      iconColor: colors.primary,
      child: Column(
        children: [
          ProgressCard(
            title: l10n.productRecycledMaterial,
            percentage: recycledMaterial,
            color: semantic.success,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: l10n.productVirginMaterial,
            percentage: virginMaterial,
            color: semantic.warning,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isMostlyRecycled ? semantic.success : semantic.warning)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isMostlyRecycled ? Icons.eco : Icons.warning,
                  color: isMostlyRecycled ? semantic.success : semantic.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isMostlyRecycled
                        ? l10n.productEcoFriendly
                        : l10n.productConsiderRecycled,
                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
