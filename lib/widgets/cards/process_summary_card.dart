import 'package:flutter/material.dart';
import 'package:dpp/widgets/subwidgets/highlighted_text.dart';
import 'package:dpp/widgets/subwidgets/circular_progress.dart';
import 'package:dpp/widgets/subwidgets/info_row.dart';
import 'package:dpp/widgets/subwidgets/divider.dart';
import 'package:dpp/styles/app_theme.dart';
import 'package:dpp/utils/hex_color.dart';
import 'package:dpp/widgets/subwidgets/piechart.dart';

class ProcessSummaryCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProcessSummaryCard({
    super.key,
    this.animationController,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              30 * (1.0 - animation!.value),
              0.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 18,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0,
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 4,
                              ),
                              child: Column(
                                children: [
                                  HighlightedTextWithIConWidget(
                                    label: 'Energy used',
                                    value: '${(3.8 * animation!.value)}',
                                    unit: 'kWh per unit',
                                    iconPath: "assets/fitness_app/electric.png",
                                    color: HexColor('#87A0E5'),
                                    animationValue: animation!.value,
                                  ),
                                  const SizedBox(height: 8),
                                  HighlightedTextWithIConWidget(
                                    label: 'CO2 Emissions',
                                    value: '${(1.25 * animation!.value)}',
                                    unit: 'kg',
                                    iconPath: "assets/fitness_app/burned.png",
                                    color: HexColor('#F56E98'),
                                    animationValue: animation!.value,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Center(
                              child: MaterialPieChartWrapped(size: 30)
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                        bottom: 8,
                      ),
                      child: CustomDividerWidget(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                        bottom: 16,
                      ),
                      child: InfoRowWidget(
                        animationValue: animation!.value,
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
}