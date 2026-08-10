import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/data_model/test/process.dart';
import 'package:dpp/app/services/test/process_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProcessDetailScreen extends StatefulWidget {
  final Process? process;
  final String? processId;

  const ProcessDetailScreen({super.key, this.process, this.processId});

  @override
  State<ProcessDetailScreen> createState() => _ProcessDetailScreenState();
}

class _ProcessDetailScreenState extends State<ProcessDetailScreen> {
  Process? process;
  String? error;

  ColorScheme get _colors => Theme.of(context).colorScheme;
  TextTheme get _text => Theme.of(context).textTheme;
  AppSemanticColors get _semantic => context.semanticColors;

  @override
  void initState() {
    super.initState();
    if (widget.process != null) {
      process = widget.process;
    } else if (widget.processId != null) {
      process = ProcessService.getProcessById(widget.processId!);
      if (process == null) {
        error = 'Process not found (ID: ${widget.processId})';
      }
    } else {
      error = 'No process information provided';
    }
  }

  String get _processId => widget.processId ?? process?.id ?? 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Details'),
        actions: [
          if (process != null)
            IconButton(icon: const Icon(Icons.qr_code), onPressed: _showQRDialog),
        ],
      ),
      body:
          error != null
              ? _buildError()
              : process == null
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: _colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 24),
            Text('Process not found', style: _text.headlineSmall),
            const SizedBox(height: 12),
            Text(
              error!,
              style: _text.bodyMedium?.copyWith(color: _colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: _colors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: _colors.shadow.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverview(),
          const SizedBox(height: 24),
          _buildProgress(),
          const SizedBox(height: 24),
          _buildEnvironmentalMetrics(),
          const SizedBox(height: 24),
          _buildTechnicalDetails(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.precision_manufacturing,
                  color: _colors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(process?.id ?? 'N/A', style: _text.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      process?.type ?? 'Unknown Type',
                      style: _text.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoRow('Manufacturer', process?.manufacturer ?? 'N/A'),
          _infoRow('Material', process?.material ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: _text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: _colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: _text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final progress = (process?.progress ?? 0).clamp(0, 100) / 100;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: _text.titleLarge),
              Text(
                '${(process?.progress ?? 0).toStringAsFixed(0)}%',
                style: _text.titleLarge?.copyWith(color: _colors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.toDouble(),
              minHeight: 10,
              backgroundColor: _colors.onSurfaceVariant.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(_colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalMetrics() {
    return _section(
      title: 'Environmental Impact',
      icon: Icons.eco,
      iconColor: _semantic.success,
      child: Column(
        children: [
          _metricCard(
            title: 'Energy Used',
            value: '${(process?.energyUsed ?? 0).toStringAsFixed(2)} kWh',
            icon: Icons.bolt,
            color: _semantic.warning,
          ),
          const SizedBox(height: 12),
          _metricCard(
            title: 'CO2 Emissions',
            value: '${(process?.co2Emissions ?? 0).toStringAsFixed(2)} kg',
            icon: Icons.cloud,
            color: _colors.error,
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _text.bodyMedium?.copyWith(
                    color: _colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: _text.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalDetails() {
    return _section(
      title: 'Technical Details',
      icon: Icons.settings,
      iconColor: _colors.onSurfaceVariant,
      child: Column(
        children: [
          _infoRow('Process ID', process?.id ?? 'N/A'),
          _infoRow('Type', process?.type ?? 'N/A'),
          _infoRow('Material', process?.material ?? 'N/A'),
          _infoRow('Manufacturer', process?.manufacturer ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(title, style: _text.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showQRDialog() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Process QR Code', style: _text.titleLarge),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _colors.outlineVariant),
                    ),
                    child: QrImageView(
                      data: _processId,
                      version: QrVersions.auto,
                      size: 180,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ID: $_processId',
                    style: _text.bodyMedium?.copyWith(
                      color: _colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
