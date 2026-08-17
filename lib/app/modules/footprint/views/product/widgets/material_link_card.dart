import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/app/modules/footprint/views/material/material_detail.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'section_card.dart';

/// Tappable card previewing the product's material (polymer type + recycled
/// % badge); pushes into [MaterialDetailScreen]. Renders nothing if the
/// product has no linked material.
class MaterialLinkCard extends StatelessWidget {
  const MaterialLinkCard({
    super.key,
    required this.product,
    required this.material,
  });

  final Product? product;
  final model.Material? material;

  @override
  Widget build(BuildContext context) {
    final materialId = product?.materialId;
    if (materialId == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    material != null
                        ? MaterialDetailScreen(material: material)
                        : MaterialDetailScreen(materialId: materialId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: cardDecoration(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.science, color: colors.secondary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.productMaterialLabel, style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    material?.polymerType ?? product?.material ?? materialId,
                    style: text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  if (material?.recycledContentPercent != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: semantic.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.productRecycledBadge(
                          material!.recycledContentPercent!.toStringAsFixed(
                            0,
                          ),
                        ),
                        style: text.labelSmall?.copyWith(
                          color: semantic.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
