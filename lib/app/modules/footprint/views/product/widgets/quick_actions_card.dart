import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'section_card.dart';

/// QR code / Share / Export / Analytics row. Share, Export, and Analytics
/// are placeholders (a "coming soon" snackbar) — only QR Code actually does
/// something, since it just needs the product's own ID.
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final semantic = context.semanticColors;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.productQuickActions, style: text.titleLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.qr_code,
                label: l10n.productActionQr,
                color: colors.primary,
                onPressed: () => showProductQrDialog(context, productId),
              ),
              _ActionButton(
                icon: Icons.share,
                label: l10n.productActionShare,
                color: semantic.success,
                onPressed: () => _comingSoon(context, l10n.productShareSoon),
              ),
              _ActionButton(
                icon: Icons.download,
                label: l10n.productActionExport,
                color: semantic.warning,
                onPressed: () => _comingSoon(context, l10n.productExportSoon),
              ),
              _ActionButton(
                icon: Icons.analytics,
                label: l10n.productActionAnalytics,
                color: semantic.info,
                onPressed:
                    () => _comingSoon(context, l10n.productAnalyticsSoon),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Shown from both the "QR Code" quick action and the AppBar's own QR
/// shortcut, so it lives at the top level rather than tucked inside
/// [QuickActionsCard].
void showProductQrDialog(BuildContext context, String productId) {
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
                Text(l10n.productQrDialogTitle, style: text.titleLarge),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: QrImageView(
                    data: productId,
                    version: QrVersions.auto,
                    size: 180,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'ID: $productId',
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, style: text.labelMedium?.copyWith(color: colors.onSurface)),
          ],
        ),
      ),
    );
  }
}
