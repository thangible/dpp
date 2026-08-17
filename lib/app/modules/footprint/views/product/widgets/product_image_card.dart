import 'package:flutter/material.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'section_card.dart';

/// The product photo, or a placeholder if it has none / the asset fails to
/// load.
class ProductImageCard extends StatelessWidget {
  const ProductImageCard({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: cardDecoration(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            (imagePath?.isNotEmpty ?? false)
                ? Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const _ImagePlaceholder(),
                )
                : const _ImagePlaceholder(),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.onSurfaceVariant.withValues(alpha: 0.1),
            colors.primary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 64,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.productNoImage,
              style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
