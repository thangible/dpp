import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'section_card.dart';

/// The product photo, or a placeholder if it has none / it fails to load.
/// Tapping it opens a full-screen, pinch-to-zoom view of the same image.
///
/// [imagePath] is either a bundled asset key ("assets/images/...png", for
/// the app's own mock products) or a `file://` URI for something
/// BasyxSyncService downloaded to local storage — that prefix is how we
/// tell the two apart. On Flutter Web there's no filesystem to download to,
/// so BasyxSyncService keeps the thumbnail bytes on the Product itself
/// instead — pass those as [imageBytes] and they take priority over
/// [imagePath] when both are set.
class ProductImageCard extends StatelessWidget {
  const ProductImageCard({super.key, required this.imagePath, this.imageBytes});

  final String? imagePath;
  final Uint8List? imageBytes;

  /// Same source, three possible backings (bytes / cached file / bundled
  /// asset) — resolved once here so the thumbnail and the full-screen
  /// viewer always show the exact same image.
  ImageProvider? _resolveProvider() {
    final bytes = imageBytes;
    if (bytes != null && bytes.isNotEmpty) return MemoryImage(bytes);

    final path = imagePath;
    if (path == null || path.isEmpty) return null;
    if (!kIsWeb && path.startsWith('file://')) {
      return FileImage(File.fromUri(Uri.parse(path)));
    }
    if (path == 'No Image') return null;
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final provider = _resolveProvider();

    // Product photos tend to be shot on a plain white background — a fixed
    // light backdrop behind BoxFit.contain lets the whole photo show without
    // cropping while still looking intentional, in light or dark theme.
    const photoBackdrop = Color(0xFFF3F3F4);

    Widget content;
    if (provider == null) {
      content = const _ImagePlaceholder();
    } else {
      content = ColoredBox(
        color: photoBackdrop,
        child: Image(
          image: provider,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
        ),
      );
    }

    final card = Container(
      width: double.infinity,
      height: 240,
      decoration: cardDecoration(context),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (provider == null) return card;

    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openFullScreen(context, provider),
            child: card,
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: _ExpandHint(onTap: () => _openFullScreen(context, provider)),
        ),
      ],
    );
  }

  void _openFullScreen(BuildContext context, ImageProvider provider) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _FullScreenImageView(provider: provider),
          );
        },
      ),
    );
  }
}

/// Small "tap to expand" affordance in the corner of the card, so the
/// enlarge behavior isn't a hidden gesture.
class _ExpandHint extends StatelessWidget {
  const _ExpandHint({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.zoom_out_map, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

/// Full-screen, pinch/drag-to-zoom view of the product photo. Dismissed by
/// the close button, tapping the backdrop, or the system back gesture.
class _FullScreenImageView extends StatelessWidget {
  const _FullScreenImageView({required this.provider});

  final ImageProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  // Swallow taps on the image itself so only the backdrop
                  // dismisses — otherwise tapping the photo to zoom in
                  // would also close the viewer.
                  child: GestureDetector(
                    onTap: () {},
                    child: Image(image: provider, fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.commonClose,
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),
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
