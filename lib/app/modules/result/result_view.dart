import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/gradient_app_bar.dart';
import 'result_controller.dart';
import '../../widgets/gradient_button.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.result;

    return Scaffold(
      appBar: const GradientAppBar(
        title: "Interview Result",
        subtitle: "AI powered performance analysis",
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF111827),
              Color(0xFF1E293B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// SCORE CARD
                FadeInDown(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 170,
                                height: 170,
                                child: CircularProgressIndicator(
                                  value: result.score / 100,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.white10,
                                  valueColor: AlwaysStoppedAnimation(
                                    _getScoreColor(result.score),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${result.score}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 46,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Overall Score",
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getScoreColor(result.score).withOpacity(0.8),
                                  _getScoreColor(result.score),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              _getPerformanceText(result.score),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// SECTIONS
                _buildSection(
                  title: "Strengths",
                  icon: Icons.check_circle_rounded,
                  items: result.strengths,
                  color: Colors.green,
                ),

                const SizedBox(height: 18),

                _buildSection(
                  title: "Weaknesses",
                  icon: Icons.cancel_rounded,
                  items: result.weaknesses,
                  color: Colors.redAccent,
                ),

                const SizedBox(height: 18),

                _buildSection(
                  title: "Suggestions",
                  icon: Icons.lightbulb_rounded,
                  items: result.suggestions,
                  color: Colors.orange,
                ),

                const SizedBox(height: 18),

                _buildSection(
                  title: "Next Topics",
                  icon: Icons.auto_awesome_rounded,
                  items: result.nextTopics,
                  color: Colors.blue,
                ),

                const SizedBox(height: 40),

                /// BUTTON
                FadeInUp(
                  child: GradientButton(
                    text: "Back To Home",
                    icon: Icons.home_rounded,
                    onTap: controller.goHome,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return FadeInUp(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// ITEMS
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          height: 1.5,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.redAccent;
  }

  String _getPerformanceText(int score) {
    if (score >= 85) return "Excellent Performance";
    if (score >= 70) return "Good Performance";
    if (score >= 50) return "Average Performance";
    return "Needs Improvement";
  }
}
