import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

/// Shown from the AppBar's QR shortcut on the material detail screen.
void showMaterialQrDialog(BuildContext context, String materialId) {
  final colors = Theme.of(context).colorScheme;
  final text = Theme.of(context).textTheme;
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder:
        (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.materialQrDialogTitle, style: text.titleLarge),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: QrImageView(
                    data: materialId,
                    version: QrVersions.auto,
                    size: 180,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'ID: $materialId',
                  style: text.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.commonClose),
                ),
              ],
            ),
          ),
        ),
  );
}
