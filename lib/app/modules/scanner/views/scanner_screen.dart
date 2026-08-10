import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/process_service.dart';
import 'package:dpp/app/modules/footprint/views/product/product_detail.dart';
import 'package:dpp/app/modules/footprint/views/process/process_detail.dart';

/// Full-screen camera scanner. Looks a decoded code up against products
/// then processes (same two-service check the search bar already does) and
/// jumps straight to whichever matches, logging it to history on the way.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;
  String? _notFoundCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    _handled = true;
    _resolve(code);
  }

  Future<void> _resolve(String code) async {
    final product = ProductService.getProductById(code);
    if (product != null) {
      await _logHistory(code, HistoryItemType.product);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      );
      return;
    }

    final process = ProcessService.getProcessById(code);
    if (process != null) {
      await _logHistory(code, HistoryItemType.process);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProcessDetailScreen(process: process),
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _notFoundCode = code);
  }

  Future<void> _logHistory(String id, HistoryItemType type) async {
    if (Get.isRegistered<HistoryController>()) {
      await Get.find<HistoryController>().addEntry(id, type);
    }
  }

  void _scanAgain() {
    setState(() {
      _handled = false;
      _notFoundCode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => _PermissionDenied(colors: colors),
          ),
          const _ScannerFrame(),
          if (_notFoundCode != null)
            _NotFoundBanner(
              code: _notFoundCode!,
              onRetry: _scanAgain,
              colors: colors,
            ),
        ],
      ),
    );
  }
}

class _ScannerFrame extends StatelessWidget {
  const _ScannerFrame();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 2.5),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _NotFoundBanner extends StatelessWidget {
  final String code;
  final VoidCallback onRetry;
  final ColorScheme colors;

  const _NotFoundBanner({
    required this.code,
    required this.onRetry,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              'No match for "$code"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Scan Again')),
          ],
        ),
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  final ColorScheme colors;

  const _PermissionDenied({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.no_photography_outlined, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Camera access needed',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enable camera access in Settings to scan a QR code.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
