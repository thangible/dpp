import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MaterialPieChartWrapped extends StatefulWidget {
  final double size;
  final List<String> titles;
  final List<double> values;
  final List<Color> colors;
  final List<double>? radii;

  const MaterialPieChartWrapped({
    super.key,
    this.size = 100,
    required this.titles,
    required this.values,
    required this.colors,
    this.radii,
  });

  @override
  State<MaterialPieChartWrapped> createState() => _MaterialPieChartWrappedState();
}

class _MaterialPieChartWrappedState extends State<MaterialPieChartWrapped> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.size),
          border: Border.all(
            width: 4,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sectionsSpace: 4,
              centerSpaceRadius: 30,
              sections: _showingSections(),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.values.length, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched
          ? (widget.radii?[i] ?? 40) + 10
          : (widget.radii?[i] ?? 40);
      final fontSize = isTouched ? 16.0 : 12.0;

      return PieChartSectionData(
        color: widget.colors[i],
        value: widget.values[i],
        title: '${widget.titles[i]}\n${widget.values[i].toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
        ),
      );
    });
  }
}
