import 'package:flutter/material.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/divider.dart';

class ProcessIdentifierCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String id;
  final DateTime? lastUpdated;
  final String? imagePath;
  final String? material;
  final String? processType;
  final String? manufacturer;
  final double? progress;

  const ProcessIdentifierCard({
    super.key,
    this.animationController,
    this.animation,
    required this.id,
    this.lastUpdated,
    this.imagePath,
    this.material,
    this.processType,
    this.manufacturer,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: buildCardTranslation(animation!.value),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: HeaderRow(
                              identifier: id,
                              lastUpdated: lastUpdated,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ImageSection(imagePath: imagePath),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: CustomDividerWidget(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ProcessInfoRow(
                        material: material ?? 'Unknown',
                        processType: processType ?? 'Unknown',
                        manufacturer: manufacturer ?? 'Unknown',
                        progress: progress ?? 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Matrix4 buildCardTranslation(double value) {
    final double translateY = 50 * (1.0 - value);
    return Matrix4.translationValues(0, translateY, 0);
  }
}

class HeaderRow extends StatelessWidget {
  final String identifier;
  final DateTime? lastUpdated;

  const HeaderRow({
    super.key,
    required this.identifier,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            identifier,
            style: textTheme.titleMedium?.copyWith(color: colors.primary),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: colors.onSurfaceVariant,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                lastUpdated != null
                    ? 'Last updated: \n${_formatTime(context, lastUpdated!)}'
                    : 'Unknown last update',
                style: textTheme.labelMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${time.format(context)}';
  }
}

class ImageSection extends StatelessWidget {
  final String? imagePath;

  const ImageSection({super.key, required this.imagePath});

  void _showFullImage(BuildContext context) {
    if (imagePath == null || imagePath == "No Image") return;
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: InteractiveViewer(
                child: Image.asset(imagePath!, fit: BoxFit.contain),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (imagePath == null || imagePath == "No Image") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 150,
          height: 150,
          color: colors.surfaceContainerHighest,
          child: Icon(
            Icons.precision_manufacturing, // Process-specific icon
            color: colors.onSurfaceVariant,
            size: 50,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _showFullImage(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(imagePath!, fit: BoxFit.cover),
          ),
        ),
      );
    }
  }
}

class ProcessInfoRow extends StatelessWidget {
  final String material;
  final String processType;
  final String manufacturer;
  final double progress;

  const ProcessInfoRow({
    super.key,
    required this.material,
    required this.processType,
    required this.manufacturer,
    required this.progress,
  });

  Widget buildColumn(BuildContext context, String value, String label) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 60, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 25, // Fixed height for value text
            alignment: Alignment.center,
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 18, // Fixed height for label text
            alignment: Alignment.center,
            child: Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgressColumn(
    BuildContext context,
    double progressValue,
    String label,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progressPercent = (progressValue).toInt();

    return Container(
      height: 60, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 25, // Fixed height for progress indicator
            alignment: Alignment.center,
            child: Stack(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    backgroundColor: colors.onSurfaceVariant.withValues(
                      alpha: 0.2,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    strokeWidth: 3,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '$progressPercent%',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 18, // Fixed height for label text
            alignment: Alignment.center,
            child: Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: buildColumn(context, material, 'Material')),
        Expanded(child: buildColumn(context, processType, 'Type')),
        Expanded(child: buildColumn(context, manufacturer, 'Manufacturer')),
        Expanded(
          child: buildProgressColumn(context, progress, 'Progress'),
        ),
      ],
    );
  }
}
