import 'package:flutter/material.dart' hide Material;
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'material_section_card.dart';

/// The header card: icon, trade name, and the material's own ID.
class MaterialOverviewCard extends StatelessWidget {
  const MaterialOverviewCard({super.key, required this.material});

  final model.Material material;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: materialCardDecoration(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.science, color: colors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(material.tradeName ?? material.id, style: text.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  material.id,
                  style: text.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
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
