import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/gradient_button.dart';
import '../../widgets/gradient_app_bar.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: const GradientAppBar(
        title: "Profile",
        subtitle: "Manage your interview profile",
      ),
      body: Center(
        child: Container(
          width: isWeb ? 600 : double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(),
                const SizedBox(height: 20),
                _formCard(context),
                const SizedBox(height: 20),
                _skillsCard(),
                const SizedBox(height: 30),
                GradientButton(
                  text: "Save Profile",
                  icon: Icons.save_rounded,
                  onTap: controller.saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white10,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Interview Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Update your details to improve AI recommendations",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= FORM =================
  Widget _formCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          _field("Name", controller.nameController),
          const SizedBox(height: 12),
          _field("Role", controller.roleController),
          const SizedBox(height: 12),

          /// EXPERIENCE
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.experience.value,
              dropdownColor: const Color(0xFF1E293B),
              decoration: _decoration("Experience"),
              items: controller.experiencesList.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: controller.setExperience,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SKILLS =================
  Widget _skillsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Skills",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// ADD SKILL
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.skillsController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration("Add Skill"),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: controller.addSkill,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// SKILLS LIST
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.skills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => controller.removeSkill(skill),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.redAccent),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= FIELD =================
  Widget _field(String hint, TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: _decoration(hint),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
