import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsChart extends StatelessWidget {
  final List<int> scores;

  const AnalyticsChart({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    final data = List.generate(
      scores.length,
      (i) => ChartData(i, scores[i]),
    );

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      primaryXAxis: NumericAxis(isVisible: false),
      primaryYAxis: NumericAxis(isVisible: false),
      plotAreaBorderWidth: 0,
      series: <LineSeries<ChartData, int>>[
        LineSeries<ChartData, int>(
          dataSource: data,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          color: Colors.blueAccent,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }
}

class ChartData {
  final int x;
  final int y;

  ChartData(this.x, this.y);
}
