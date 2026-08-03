import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_ai/app/modules/home/home_controller.dart';
import '../../services/storage_service.dart';

class ProfileController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  HomeController homeController = Get.find<HomeController>();

  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final skillsController = TextEditingController();

  final experiencesList = [
    "0-1 years",
    "2 years",
    "3 years",
    "4 years",
    "5+ years",
  ];

  var name = "".obs;
  var role = "".obs;
  var experience = "0-1 years".obs;
  var skills = <String>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    isLoading.value = true;

    final profile = _storage.getProfile();

    if (profile != null) {
      nameController.text = profile["name"] ?? "";
      roleController.text = profile["role"] ?? "";
      skills.assignAll(List<String>.from(profile["skills"] ?? []));

      name.value = profile["name"] ?? "";
      role.value = profile["role"] ?? "";
      experience.value = profile["experience"] ?? "Fresher";
    }

    isLoading.value = false;
  }

  void addSkill() {
    final text = skillsController.text.trim();
    if (text.isEmpty) return;

    if (!skills.contains(text)) {
      skills.add(text);
    }

    skillsController.clear();
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  void setExperience(String? value) {
    if (value != null) experience.value = value;
  }

  void saveProfile() {
    final profileData = {
      "name": nameController.text.trim(),
      "role": roleController.text.trim(),
      "experience": experience.value,
      "skills": skills.toList(),
      "updatedAt": DateTime.now().toIso8601String(),
    };

    _storage.saveProfile(profileData);
    homeController.refreshProfile();

    Get.snackbar(
      "Success",
      "Profile saved successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.2),
      colorText: Colors.white,
    );

    // Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    roleController.dispose();
    skillsController.dispose();
    super.onClose();
  }
}
