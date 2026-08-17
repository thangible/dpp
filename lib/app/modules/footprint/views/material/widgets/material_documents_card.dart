import 'package:flutter/material.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'material_section_card.dart';

/// The Documents section: a plain list of document names (TDS, SDS, CoA,
/// declarations, ...) with a file icon each.
class MaterialDocumentsCard extends StatelessWidget {
  const MaterialDocumentsCard({super.key, required this.documents});

  final List<String> documents;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: materialCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: colors.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(l10n.materialSectionDocuments, style: text.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          if (documents.isEmpty)
            Text(
              l10n.commonNA,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            )
          else
            ...documents.map(
              (doc) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 18,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(doc, style: text.bodyMedium)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
