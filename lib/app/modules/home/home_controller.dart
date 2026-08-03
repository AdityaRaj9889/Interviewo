import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final experiences = [
    "0-1 years",
    "2 years",
    "3 years",
    "4 years",
    "5+ years",
  ];

  final selectedExperience = "0-1 years".obs;

  final jobDescriptionController = TextEditingController();

  final selectedTechStack = <String>[].obs;

  final techOptions = [
    "Flutter",
    "Firebase",
    "Node.js",
    "React",
    "AWS",
    "MongoDB",
    "REST API",
    "Dart",
    "Python",
  ];

  final interviewMode = 'chat'.obs;

  final history = <dynamic>[].obs;
  final profile = Rxn<Map<String, dynamic>>();

  final List<Map<String, dynamic>> interviewCards = const [
    {
      "title": "MERN Developer",
      "icon": Icons.javascript_rounded,
      "desc": "MongoDB, Express, React, Node.js",
      "color": [Color(0xFF22C55E), Color(0xFF16A34A)],
    },
    {
      "title": "Flutter Developer",
      "icon": Icons.phone_iphone_rounded,
      "desc": "Flutter, Dart, Firebase, Mobile UI",
      "color": [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    },
    {
      "title": "Frontend Developer",
      "icon": Icons.web_rounded,
      "desc": "HTML, CSS, JavaScript, React",
      "color": [Color(0xFFF59E0B), Color(0xFFEF4444)],
    },
    {
      "title": "Backend Developer",
      "icon": Icons.storage_rounded,
      "desc": "APIs, Databases, Servers",
      "color": [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    },
    {
      "title": "Full Stack Developer",
      "icon": Icons.layers_rounded,
      "desc": "Frontend + Backend + Database",
      "color": [Color(0xFF0EA5E9), Color(0xFF6366F1)],
    },
    {
      "title": "PHP Developer",
      "icon": Icons.code_rounded,
      "desc": "PHP, MySQL, Laravel basics",
      "color": [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      "title": "Laravel Developer",
      "icon": Icons.api_rounded,
      "desc": "Laravel, PHP, MVC, REST APIs",
      "color": [Color(0xFFEF4444), Color(0xFF991B1B)],
    },
    {
      "title": "DevOps Engineer",
      "icon": Icons.settings_suggest_rounded,
      "desc": "CI/CD, Docker, AWS, Deployment",
      "color": [Color(0xFFF97316), Color(0xFFEA580C)],
    },
    {
      "title": "AI / ML Engineer",
      "icon": Icons.psychology_alt_rounded,
      "desc": "Models, Data Science, AI Systems",
      "color": [Color(0xFFEC4899), Color(0xFFBE185D)],
    },
    {
      "title": "System Design",
      "icon": Icons.account_tree_rounded,
      "desc": "Scalability, Architecture, Design Patterns",
      "color": [Color(0xFF6366F1), Color(0xFF4338CA)],
    },
    {
      "title": "DSA Interview",
      "icon": Icons.data_object_rounded,
      "desc": "Arrays, Trees, Graphs, DP",
      "color": [Color(0xFF2563EB), Color(0xFF1E40AF)],
    },
    {
      "title": "HR Interview",
      "icon": Icons.people_rounded,
      "desc": "Behavior, Communication, Soft Skills",
      "color": [Color(0xFFEF4444), Color(0xFF991B1B)],
    },
    {
      "title": "Custom Role",
      "icon": Icons.edit_rounded,
      "desc": "Enter your own job role",
      "color": [Color(0xFF22C55E), Color(0xFF16A34A)],
      "isCustom": true,
    }
  ];
  @override
  void onInit() {
    super.onInit();
    loadHistory();
    loadProfile();
  }

  void loadProfile() {
    profile.value = _storageService.getProfile();
  }

  void loadHistory() {
    history.value = _storageService.getHistory();
  }

  void refreshProfile() {
    profile.value = _storageService.getProfile();
  }

  void startInterview(String type, String mode,
      {required String experience,
      String? jobDescription,
      List<String>? techStack}) {
    Get.toNamed(
      '/interview',
      arguments: {
        'type': type,
        'mode': mode,
        'experience': experience,
        'jobDescription': jobDescription,
        'techStack': techStack,
      },
    );
  }
}
