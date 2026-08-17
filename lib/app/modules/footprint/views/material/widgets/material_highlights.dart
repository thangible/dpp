import 'package:flutter/material.dart' hide Material;
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/l10n/generated/app_localizations.dart';

/// The 5 yellow-highlighted fields from the field spec, shown as icon tiles
/// above the regular sections: Polymer Type, Recycled Content (as a
/// green→red gauge), Origin, CO2 Footprint, Manufacturer ID.
class MaterialHighlights extends StatelessWidget {
  const MaterialHighlights({super.key, required this.material});

  final model.Material material;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final m = material;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _HighlightTile(
          icon: Icons.category_outlined,
          label: l10n.materialHighlightPolymerType,
          value: m.polymerType ?? l10n.commonNA,
        ),
        _RecycledContentTile(percent: m.recycledContentPercent),
        _HighlightTile(
          icon: Icons.public,
          label: l10n.materialHighlightOrigin,
          value: m.recycledOrigin ?? l10n.commonNA,
        ),
        _HighlightTile(
          icon: Icons.cloud_outlined,
          label: l10n.materialHighlightCo2,
          value:
              m.co2FootprintPerKg != null
                  ? '${m.co2FootprintPerKg} kg/kg'
                  : l10n.commonNA,
        ),
        _HighlightTile(
          icon: Icons.badge_outlined,
          label: l10n.materialHighlightManufacturerId,
          value: m.manufacturerId ?? l10n.commonNA,
        ),
      ],
    );
  }
}

/// Compact icon-tile used for the four non-gauge highlight fields.
class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// The recycled-content highlight: a green→red gradient gauge instead of a
/// plain value, so "how sustainable is this" reads at a glance.
class _RecycledContentTile extends StatelessWidget {
  const _RecycledContentTile({required this.percent});

  final double? percent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context)!;

    final value = (percent ?? 0).clamp(0, 100) / 100;
    final gaugeColor = Color.lerp(colors.error, semantic.success, value)!;

    return Container(
      width: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.recycling, color: gaugeColor, size: 20),
              const Spacer(),
              Text(
                percent != null ? '${percent!.toStringAsFixed(0)}%' : l10n.commonNA,
                style: textTheme.titleSmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: colors.surfaceContainerHighest),
                  FractionallySizedBox(
                    widthFactor: value.toDouble(),
                    child: Container(color: gaugeColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.materialHighlightRecycledContent,
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
