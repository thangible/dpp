import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/divider.dart';

class ProcessIdentifierCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  // Add a machine data parameter (you can create a Machine class or use Map)
  final Map<String, dynamic> machineData;

  const ProcessIdentifierCard({
    super.key,
    this.animationController,
    this.animation,
    required this.machineData,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: buildCardTranslation(animation!.value),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeaderRow(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: CustomDividerWidget(),
                    ),
                    _buildDetailsRow(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    final lastUpdated = machineData['lastUpdated'] != null
        ? DateTime.parse(machineData['lastUpdated']).toLocal()
        : DateTime.now();

    final formattedLastUpdated =
        "${lastUpdated.day}/${lastUpdated.month}/${lastUpdated.year} ${lastUpdated.hour}:${lastUpdated.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    machineData['type'] ?? 'Unknown Type',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.nearlyDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: AppTheme.grey.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Last updated: $formattedLastUpdated',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: AppTheme.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageLink = machineData['imageLink'] ?? 'assets/images/machine_example.png';

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              imageLink,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // fallback if image not found
                return Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsRow() {
    // Replace with dynamic data or defaults
    final material = machineData['matetrial'] ?? 'Unknown';
    final manufacturer = machineData['manufacturer'] ?? 'Unknown';
    final virginMaterial = (machineData['virginMaterial'] != null)
        ? (machineData['virginMaterial'] * 100).toStringAsFixed(0) + '%'
        : 'N/A';
    final recycledMaterial = (machineData['recycledMaterial'] != null)
        ? (machineData['recycledMaterial'] * 100).toStringAsFixed(0) + '%'
        : 'N/A';

    final progress = 0.6; // Example progress, could be from data if available
    final progressPercent = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Row(
        children: <Widget>[
          _buildDetailColumn(material, 'Material', Alignment.centerLeft),
          _buildDetailColumn(manufacturer, 'Manufacturer', Alignment.center),
          _buildDetailColumn('Virgin: $virginMaterial', 'Virgin Material', Alignment.centerRight),
          _buildDetailColumn('Recycled: $recycledMaterial', 'Recycled Material', Alignment.centerRight),
          _buildProgressColumn(progress, progressPercent),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String value, String label, Alignment alignment) {
    return Expanded(
      child: Align(
        alignment: alignment,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: -0.2,
                color: AppTheme.darkText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppTheme.grey.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressColumn(double progressValue, int progressPercent) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progressValue,
                  backgroundColor: AppTheme.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.nearlyDarkBlue),
                  strokeWidth: 6,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '$progressPercent%',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Progress',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppTheme.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

Matrix4 buildCardTranslation(double animationValue) {
  return Matrix4.translationValues(0.0, 30 * (1.0 - animationValue), 0.0);
}
