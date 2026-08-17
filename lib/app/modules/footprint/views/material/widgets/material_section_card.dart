import 'package:flutter/material.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

/// The white rounded-corner, soft-shadow card every material-detail section
/// sits in.
BoxDecoration materialCardDecoration(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return BoxDecoration(
    color: colors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: colors.shadow.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

/// One of the material's 7 field-spec sections, rendered as a titled table
/// of label:value rows. A null value shows as "N/A".
class MaterialSectionCard extends StatelessWidget {
  const MaterialSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.rows,
  });

  final String title;
  final IconData icon;
  final List<(String, String?)> rows;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: materialCardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.onSurfaceVariant, size: 22),
                const SizedBox(width: 12),
                Text(title, style: text.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        row.$1,
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.$2 ?? l10n.commonNA,
                        style: text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
