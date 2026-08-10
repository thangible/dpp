import 'package:flutter/material.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/highlighted_text.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/info_row.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/divider.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/piechart.dart';

// import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/speedometer.dart';
class ProductSummaryCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final double? energyUsed;
  final double? co2Emissions;

  const ProductSummaryCard({
    super.key,
    this.energyUsed,
    this.co2Emissions,
    this.animationController,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return ProductCardContainer(
      animationController: animationController!,
      animation: animation!,
      child: ProductCardContent(
        data: {'energyUsed': energyUsed, 'co2Emissions': co2Emissions},
        animation: animation!,
      ),
    );
  }
}

/// Container with animation and styling for the card
class ProductCardContainer extends StatelessWidget {
  final Widget child;
  final AnimationController animationController;
  final Animation<double> animation;

  const ProductCardContainer({
    super.key,
    required this.child,
    required this.animationController,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              30 * (1.0 - animation.value),
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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Content inside the card, split into rows and info widgets
class ProductCardContent extends StatelessWidget {
  final Map<String, dynamic> data;
  final Animation<double> animation;

  const ProductCardContent({
    super.key,
    required this.data,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: EnergyAndEmissionInfo(
                  energyUsed: data['energyUsed'],
                  co2Emissions: data['co2Emissions'],
                  animation: animation,
                ),
              ),
              Expanded(child: PieChartSection()),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: CustomDividerWidget(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: InfoRowWidget(animationValue: animation.value),
        ),
      ],
    );
  }
}

/// Widget showing energy used and CO2 emissions info
class EnergyAndEmissionInfo extends StatelessWidget {
  final double? energyUsed;
  final double? co2Emissions;
  final Animation<double> animation;

  const EnergyAndEmissionInfo({
    super.key,
    this.energyUsed,
    this.co2Emissions,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final chartPalette = context.semanticColors.chartPalette;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
      child: Column(
        children: [
          HighlightedTextWithIConWidget(
            label: 'Energy used',
            value:
                energyUsed != null
                    ? (energyUsed! * animation.value).toStringAsFixed(0)
                    : 'N/A',
            unit: 'kWh',
            iconPath: "assets/fitness_app/electric.png",
            color: chartPalette[0],
            animationValue: animation.value,
          ),
          const SizedBox(height: 8),
          HighlightedTextWithIConWidget(
            label: 'CO2 Emissions',
            value:
                co2Emissions != null
                    ? (co2Emissions! * animation.value).toStringAsFixed(0)
                    : 'N/A',
            unit: 'kg',
            iconPath: "assets/fitness_app/burned.png",
            color: chartPalette[1],
            animationValue: animation.value,
          ),
        ],
      ),
    );
  }
}

/// Widget for the pie chart section
class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: MaterialPieChartWrapped(
          size: 80,
          titles: const ['Virgin', 'Scrap', 'Others'],
          values: const [10, 60, 30],
          colors: context.semanticColors.chartPalette,
          radii: const [40, 40, 40],
        ),
      ),
    );
  }
}
