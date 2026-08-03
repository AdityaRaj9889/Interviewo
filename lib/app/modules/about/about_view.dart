import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../../widgets/gradient_app_bar.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: const GradientAppBar(
        title: Constants.appName,
        subtitle: Constants.appTagline,
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// APP CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.psychology_rounded,
                      size: 60,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "About",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Constants.appDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// FEATURES
              _sectionTitle("What You Can Do"),

              const SizedBox(height: 15),

              _featureItem("Practice technical interview questions"),
              _featureItem("Attend realistic AI interview sessions"),
              _featureItem("Get instant feedback on your answers"),
              _featureItem("Improve communication and confidence"),
              _featureItem("Prepare for HR and behavioral interviews"),
              _featureItem("Track areas that need improvement"),
              _featureItem("Learn from personalized suggestions"),

              const SizedBox(height: 30),

              /// VERSION
              _sectionTitle("App Version"),

              const SizedBox(height: 15),

              _infoCard(
                title: "Version",
                value: Constants.appVersion,
                icon: Icons.verified_rounded,
              ),

              const SizedBox(height: 30),

              /// ABOUT
              _sectionTitle("About"),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Text(
                  Constants.aboutText,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// MOTIVATION CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF7C3AED),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Prepare Better. Perform Better.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Practice anytime, improve continuously, and walk into interviews with confidence.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "© 2025 ${Constants.appName}",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF2563EB),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade300,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
