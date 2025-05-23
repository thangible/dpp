import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dpp/fitness_app/fitness_app_theme.dart';
import 'package:dpp/utils/hex_color.dart';

class MaterialPieChartWrapped extends StatelessWidget {
  final double size;

  const MaterialPieChartWrapped({this.size = 100, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: FitnessAppTheme.white,
              borderRadius: BorderRadius.all(
                Radius.circular(size), // match circular border
              ),
              border: Border.all(
                width: 4,
                color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // same inner padding
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 30,
                  sections: _showingSections(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    return [
      PieChartSectionData(
        color: HexColor('#87A0E5'),
        value: 10,
        title: 'Virgin\n10%',
        radius: 40,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      PieChartSectionData(
        color: HexColor('#F56E98'),
        value: 60,
        title: 'Recycled\nfrom Scrap\n60%',
        radius: 40,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: HexColor('#F1B440'),
        value: 30,
        title: 'Recycled\nfrom Others\n30%',
        radius: 40,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ];
  }
}
