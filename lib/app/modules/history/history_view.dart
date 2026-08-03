import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/gradient_app_bar.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: const GradientAppBar(
        title: "Interview History",
        subtitle: "Track your progress over time",
      ),
      body: Obx(() {
        if (controller.historyList.isEmpty) {
          return const Center(
            child: Text(
              "No Interviews Yet",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 25),
              _buildChart(),
              const SizedBox(height: 25),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.historyList.length,
                itemBuilder: (context, index) {
                  final item = controller.historyList[index];

                  final score = (item['score'] ?? 0);
                  final intScore = score is int
                      ? score
                      : int.tryParse(score.toString()) ?? 0;

                  return _buildHistoryCard(item, intScore);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // ================= SUMMARY =================
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat("Avg", controller.averageScore.toStringAsFixed(1)),
          _stat("Best", controller.bestScore.toString()),
          _stat("Total", controller.totalInterviews.toString()),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  // ================= CHART (FIXED) =================
  Widget _buildChart() {
    final data = controller.scores.asMap().entries.map((e) {
      return ChartData(e.key, e.value);
    }).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          minimum: 0,
          maximum: 100,
        ),
        series: <LineSeries<ChartData, int>>[
          LineSeries<ChartData, int>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            color: Colors.blueAccent,
            width: 3,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
            ),
            animationDuration: 800,
          )
        ],
      ),
    );
  }

  // ================= HISTORY CARD =================
  Widget _buildHistoryCard(Map<String, dynamic> item, int score) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _getScoreColor(score),
              ),
            ),
            child: Center(
              child: Text(
                "$score",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['type'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _getPerformanceText(score),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  List<Color> _getScoreColor(int score) {
    if (score >= 80) return [Colors.green, Colors.teal];
    if (score >= 60) return [Colors.orange, Colors.deepOrange];
    return [Colors.redAccent, Colors.red];
  }

  String _getPerformanceText(int score) {
    if (score >= 85) return "Excellent";
    if (score >= 70) return "Good";
    if (score >= 50) return "Average";
    return "Needs Improvement";
  }
}

// ================= MODEL =================
class ChartData {
  final int x;
  final int y;

  ChartData(this.x, this.y);
}
