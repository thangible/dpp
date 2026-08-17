import 'package:flutter/material.dart';

/// The white rounded-corner, soft-shadow card every product-detail section
/// sits in. Centralized here so all the section cards share one look.
BoxDecoration cardDecoration(BuildContext context) {
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

/// A titled card: icon + heading, then whatever content the section needs.
/// Used by every "grouped metrics" section (Carbon Footprint, Environmental
/// Impact, Material Composition, Technical Details).
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(title, style: text.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
