import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_ai/constants/constants.dart';

import '../../../utils/responsive_font.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/input_field.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveFont.size(context, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Track your growth & practice smarter",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveFont.size(context, 13),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _topButton(Icons.history, "History", "/history"),
                        const SizedBox(width: 10),
                        _topButton(Icons.person, "Profile", "/profile"),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                _buildStats(),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.15),
                        Colors.purple.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Your performance improves with consistency. Keep going!",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveFont.size(context, 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  "Start Interview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveFont.size(context, 18),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Choose your interview type",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.interviewCards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 1000
                        ? 4
                        : width > 700
                            ? 3
                            : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (_, index) {
                    final card = controller.interviewCards[index];
                    return _buildCard(card, context);
                  },
                ),

                const SizedBox(height: 30),

                /// ================= FOOTER =================
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveFont.size(context, 14),
                      ),
                      children: [
                        const TextSpan(text: 'Made with '),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                        const TextSpan(text: ' India | '),
                        TextSpan(
                          text: 'About',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed('/about');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    final scores = controller.history.map((e) => e['score'] as int).toList();

    final avg =
        scores.isEmpty ? 0 : scores.reduce((a, b) => a + b) ~/ scores.length;

    final best = scores.isEmpty ? 0 : scores.reduce((a, b) => a > b ? a : b);

    return Row(
      children: [
        _statCard("Avg", "$avg", Colors.blue),
        const SizedBox(width: 10),
        _statCard("Best", "$best", Colors.green),
        const SizedBox(width: 10),
        _statCard("Total", "${controller.history.length}", Colors.purple),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= CARD =================
  Widget _buildCard(Map<String, dynamic> card, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showSetupSheet(card["title"], context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: card["color"]),
          boxShadow: [
            BoxShadow(
              color: card["color"][0].withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(card["icon"], color: Colors.white, size: 28),
              const Spacer(),
              Text(
                card["title"],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveFont.size(context, 15),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                card["desc"],
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: ResponsiveFont.size(context, 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topButton(IconData icon, String label, String route) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 600;

        return InkWell(
          onTap: () => Get.toNamed(route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                if (!isMobile) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveFont.size(context, 14),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSetupSheet(String type, BuildContext context) {
    final customTechController = TextEditingController();
    final customRoleController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final techFormKey = GlobalKey<FormState>();

    final useProfile = false.obs;
    final selectedMode = "chat".obs;

    controller.selectedTechStack.clear();
    controller.jobDescriptionController.clear();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Obx(
        () => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF111827),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ScrollConfiguration(
            behavior:
                const MaterialScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveFont.size(context, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          _modeButton(
                            title: "Chat Mode",
                            icon: Icons.chat_bubble_rounded,
                            isActive: selectedMode.value == "chat",
                            onTap: () => selectedMode.value = "chat",
                          ),
                          const SizedBox(width: 8),
                          _modeButton(
                            title: "Mock Mode",
                            icon: Icons.mic_rounded,
                            isActive: selectedMode.value == "mock",
                            onTap: () => selectedMode.value = "mock",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// ================= PROFILE CHECKBOX =================
                    CheckboxListTile(
                      value: useProfile.value,
                      onChanged: (v) {
                        useProfile.value = v!;
                        if (v) {
                          final profile = controller.profile.value;
                          if (profile != null) {
                            controller.selectedExperience.value =
                                profile["experience"] ?? "0-1 years";

                            controller.selectedTechStack.clear();
                            controller.selectedTechStack.addAll(
                              List<String>.from(profile["skills"] ?? []),
                            );
                            if (type.toLowerCase() == "custom role") {
                              customRoleController.text = profile["role"] ?? "";
                            }
                          }
                        } else {
                          controller.selectedTechStack.clear();
                          controller.jobDescriptionController.clear();
                          customRoleController.clear();
                          controller.selectedExperience.value = "0-1 years";
                        }
                      },
                      title: const Text(
                        "Use Profile Data",
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 15),

                    /// ================= ROLE =================
                    if (type.toLowerCase() == "custom role") ...[
                      InputField(
                        controller: customRoleController,
                        hint: "Enter role (e.g. Flutter Developer)",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Role cannot be empty";
                          }
                          if (value.length < 5) {
                            return "Too short";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    /// ================= EXPERIENCE =================
                    const Text("Experience",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: controller.selectedExperience.value,
                      dropdownColor: const Color(0xFF1E293B),
                      style: const TextStyle(color: Colors.white),
                      decoration: _dec("Experience"),
                      items: controller.experiences
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          controller.selectedExperience.value = v!,
                    ),

                    const SizedBox(height: 20),

                    /// ================= JOB DESCRIPTION =================
                    InputField(
                      controller: controller.jobDescriptionController,
                      hint: "Optional JD",
                      maxLines: 4,
                    ),

                    const SizedBox(height: 20),

                    /// ================= TECH STACK =================
                    const Text("Tech Stack",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),

                    Obx(
                      () => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.techOptions.map((tech) {
                          final selected = controller.selectedTechStack.any(
                              (e) => e.toLowerCase() == tech.toLowerCase());

                          return FilterChip(
                            selected: selected,
                            showCheckmark: false,
                            label: Text(tech),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.white70,
                            ),
                            selectedColor: const Color(0xFF2563EB),
                            backgroundColor: Colors.white10,
                            onSelected: (v) {
                              if (v) {
                                controller.selectedTechStack.add(tech);
                              } else {
                                controller.selectedTechStack.remove(tech);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// ================= CUSTOM TECH =================
                    Form(
                      key: techFormKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: InputField(
                              controller: customTechController,
                              hint: "Add custom tech",
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Tech cannot be empty";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              final isValid =
                                  techFormKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              final tech = customTechController.text.trim();

                              if (!controller.techOptions.contains(tech)) {
                                controller.techOptions.add(tech);
                              }

                              controller.selectedTechStack.add(tech);
                              customTechController.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF2563EB),
                                    Color(0xFF7C3AED)
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// ================= START BUTTON =================
                    GradientButton(
                      text: "Start Interview",
                      icon: Icons.play_arrow,
                      onTap: () {
                        final isValid =
                            formKey.currentState?.validate() ?? false;
                        if (!isValid) return;

                        Get.back();

                        controller.startInterview(
                          type.toLowerCase() == "custom role"
                              ? customRoleController.text.trim()
                              : type,
                          selectedMode.value, // 👈 CHAT / MOCK SENT HERE
                          experience: controller.selectedExperience.value,
                          jobDescription:
                              controller.jobDescriptionController.text.trim(),
                          techStack: controller.selectedTechStack,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  Widget _modeButton({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                  )
                : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18, color: isActive ? Colors.white : Colors.white70),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
