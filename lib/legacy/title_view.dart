import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dpp/app/modules/footprint/views/product/product_detail.dart';
import 'package:dpp/legacy/process_detail.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/legacy/process_model.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final String? productID;
  final Product? product;
  final Process? process;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const TitleView({
    super.key,
    this.titleTxt = "",
    this.subTxt = "",
    this.productID = "",
    this.product,
    this.process,
    required this.animationController,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return _buildAnimatedContainer(context);
      },
    );
  }

  Widget _buildAnimatedContainer(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          30 * (1.0 - animation!.value),
          0.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildTitleRow(context),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            titleTxt,
            textAlign: TextAlign.left,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            if (subTxt == "Get QR Code") {
              _showQRCodeDialog(context);
            } else if (subTxt == "Details" && product != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductDetailScreen(
                        product: product,
                        animationController: animationController,
                      ),
                ),
              );
            } else if (subTxt == "Details" && process != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProcessDetailScreen(process: process),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: <Widget>[
                Text(
                  subTxt,
                  textAlign: TextAlign.left,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.5,
                    color: colors.primary,
                  ),
                ),
                SizedBox(
                  height: 38,
                  width: 26,
                  child: Icon(
                    Icons.arrow_forward,
                    color: colors.onSurface,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    productID != null && productID!.isNotEmpty
                        ? "Scan QR Code"
                        : "No Product ID",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (productID != null && productID!.isNotEmpty)
                    QrImageView(
                      data: productID!,
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
