import 'package:dpp/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final String? productID;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const TitleView({
    super.key,
    this.titleTxt = "",
    this.subTxt = "",
    this.productID = "",
    this.animationController,
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
        transform: Matrix4.translationValues(0.0, 30 * (1.0 - animation!.value), 0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildTitleRow(context),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            titleTxt,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
              color: AppTheme.lightText,
            ),
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            if (subTxt == "Get QR Code") {
              _showQRCodeDialog(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: <Widget>[
                Text(
                  subTxt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    color: AppTheme.nearlyDarkBlue,
                  ),
                ),
                const SizedBox(
                  height: 38,
                  width: 26,
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppTheme.darkText,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        )
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
                    productID != null && productID!.isNotEmpty ? "Scan QR Code" : "No Product ID",
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
