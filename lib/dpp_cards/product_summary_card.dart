import 'package:flutter/material.dart';
import 'package:dpp/dpp_cards/widgets/co2_counter.dart';
import 'package:dpp/dpp_cards/widgets/circular_progress.dart';
import 'package:dpp/dpp_cards/widgets/macronutrient_row.dart';
import 'package:dpp/dpp_cards/widgets/divider.dart';
import 'package:dpp/fitness_app/fitness_app_theme.dart';
import 'package:dpp/utils/hex_color.dart';

class ProductSummaryCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProductSummaryCard({
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
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.2),
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
                                  CO2Counter(
                                    label: 'Eaten',
                                    value: '${(1127 * animation!.value).toInt()}',
                                    unit: 'Kcal',
                                    iconPath: "assets/fitness_app/eaten.png",
                                    color: HexColor('#87A0E5'),
                                    animationValue: animation!.value,
                                  ),
                                  const SizedBox(height: 8),
                                  CO2Counter(
                                    label: 'Burned',
                                    value: '${(102 * animation!.value).toInt()}',
                                    unit: 'Kcal',
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
                              child: CustomCircularProgressIndicator(
                                animationValue: animation!.value,
                                currentValue: (1503 * animation!.value).toInt(),
                              ),
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
                      child: CustomDivider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                        bottom: 16,
                      ),
                      child: MacronutrientRow(
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