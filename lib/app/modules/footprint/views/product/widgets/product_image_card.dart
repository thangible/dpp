import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'section_card.dart';

/// The product photo, or a placeholder if it has none / it fails to load.
///
/// [imagePath] is either a bundled asset key ("assets/images/...png", for
/// the app's own mock products) or a `file://` URI for something
/// BasyxSyncService downloaded to local storage — that prefix is how we
/// tell the two apart.
class ProductImageCard extends StatelessWidget {
  const ProductImageCard({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    Widget image;
    if (path == null || path.isEmpty) {
      image = const _ImagePlaceholder();
    } else if (path.startsWith('file://')) {
      image = Image.file(
        File.fromUri(Uri.parse(path)),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
      );
    } else {
      image = Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
      );
    }

    return Container(
      width: double.infinity,
      height: 220,
      decoration: cardDecoration(context),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: image),
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
