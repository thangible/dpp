import 'package:flutter/material.dart';
import 'package:dpp/widgets/subwidgets/co2_counter.dart';
import 'package:dpp/widgets/subwidgets/circular_progress.dart';
import 'package:dpp/widgets/subwidgets/macronutrient_row.dart';
import 'package:dpp/widgets/subwidgets/divider.dart';
import 'package:dpp/styles/app_theme.dart';
import 'package:dpp/utils/hex_color.dart';
import 'package:dpp/widgets/subwidgets/piechart.dart';
import 'package:dpp/services/product_service.dart'; // Your mock service

class ProductSummaryCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
   final String machineId;

  const ProductSummaryCard({
    required this.machineId,
    super.key,
    this.animationController,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ProductSummaryService.fetchProductSummaryData(machineId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final energyUsed = data['energyUsed'] ?? 0;
        final co2Emissions = data['co2Emissions'] ?? 0;

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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(68.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppTheme.grey.withOpacity(0.2),
                          offset: const Offset(1.1, 1.1),
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
                                        label: 'Energy used',
                                        value: '${(energyUsed * animation!.value)}',
                                        unit: 'kWh per unit',
                                        iconPath: "assets/fitness_app/electric.png",
                                        color: HexColor('#87A0E5'),
                                        animationValue: animation!.value,
                                      ),
                                      const SizedBox(height: 8),
                                      CO2Counter(
                                        label: 'CO2 Emissions',
                                        value: '${(co2Emissions * animation!.value)}',
                                        unit: 'kg',
                                        iconPath: "assets/fitness_app/burned.png",
                                        color: HexColor('#F56E98'),
                                        animationValue: animation!.value,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Center(
                                  child: MaterialPieChartWrapped(size: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: CustomDivider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      },
    );
  }
}
