import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../widgets/gradient_app_bar.dart';
import 'interview_controller.dart';

class InterviewView extends GetView<InterviewController> {
  const InterviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: GradientAppBar(
        title: controller.interviewType.value,
        subtitle: "Question ${controller.questionCount.value}",
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.toggleTts,
              icon: Icon(
                controller.isTtsEnabled
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
        child: Obx(
          () => controller.interviewMode.value == 'mock'
              ? _buildMockUI()
              : _buildChatUI(),
        ),
      ),
    );
  }

  // ================= CHAT UI =================

  Widget _buildChatUI() {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(18),
              itemCount: controller.messages.length,
              itemBuilder: (_, index) {
                final message = controller.messages[index];
                final isAI = message.sender == 'ai';

                return FadeInUp(
                  child: Align(
                    alignment:
                        isAI ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(maxWidth: Get.width * 0.82),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(24),
                          topRight: const Radius.circular(24),
                          bottomLeft: Radius.circular(isAI ? 6 : 24),
                          bottomRight: Radius.circular(isAI ? 24 : 6),
                        ),
                        gradient: isAI
                            ? LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.06),
                                  Colors.white.withOpacity(0.03),
                                ],
                              )
                            : const LinearGradient(
                                colors: [
                                  Color(0xFF2563EB),
                                  Color(0xFF7C3AED),
                                ],
                              ),
                        border: Border.all(
                          color: isAI
                              ? Colors.white.withOpacity(0.05)
                              : Colors.transparent,
                        ),
                        boxShadow: [
                          if (!isAI)
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // typing indicator
        Obx(
          () => controller.isTyping.value
              ? const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SpinKitThreeBounce(
                      color: Color(0xFF2563EB),
                      size: 18,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        // input / result button
        Obx(
          () => controller.isInterviewEnded.value
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: _primaryButton(
                    text: "View Interview Result",
                    icon: Icons.analytics_rounded,
                    onTap: controller.goToResults,
                  ),
                )
              : _buildInputArea(),
        ),
      ],
    );
  }

  // ================= MOCK UI =================

  Widget _buildMockUI() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: controller.isListening.value
                        ? [
                            Colors.red.withOpacity(0.6),
                            Colors.redAccent.withOpacity(0.3),
                          ]
                        : [
                            const Color(0xFF2563EB).withOpacity(0.6),
                            const Color(0xFF7C3AED).withOpacity(0.4),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (controller.isListening.value
                              ? Colors.red
                              : Colors.blue)
                          .withOpacity(0.25),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  controller.isListening.value
                      ? Icons.mic_rounded
                      : Icons.psychology_rounded,
                  size: 90,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Obx(
              () => Text(
                controller.isListening.value
                    ? "Listening..."
                    : "AI is Speaking...",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                controller.isListening.value
                    ? controller.textController.text
                    : "Wait for the next question...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Obx(
              () => controller.isInterviewEnded.value
                  ? _primaryButton(
                      text: "View Result",
                      icon: Icons.analytics_rounded,
                      onTap: controller.goToResults,
                    )
                  : GestureDetector(
                      onLongPress: controller.startVoiceInput,
                      onLongPressUp: controller.stopVoiceInput,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF2563EB),
                              Color(0xFF7C3AED),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            if (!controller.isInterviewEnded.value)
              Text(
                "Hold to Speak",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT =================

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
              child: TextField(
                controller: controller.textController,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Type your answer...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF7C3AED),
                  ],
                ),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BUTTON =================

  Widget _primaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF7C3AED),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
