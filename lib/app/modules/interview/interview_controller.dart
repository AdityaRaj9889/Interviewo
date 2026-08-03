import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/interview_model.dart';
import '../../services/ai_service.dart';
import '../../services/storage_service.dart';
import '../../services/voice_service.dart';

class InterviewController extends GetxController {
  final AIService _aiService = Get.find<AIService>();
  final StorageService _storageService = Get.find<StorageService>();
  final VoiceService _voiceService = Get.find<VoiceService>();

  final messages = <MessageModel>[].obs;

  final isListening = false.obs;
  final isLoading = false.obs;
  final isTyping = false.obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  RxString interviewType = "".obs;
  RxString interviewMode = "".obs;

  var questionCount = 0.obs;
  var isInterviewEnded = false.obs;

  InterviewResult? finalResult;

  late Map<String, dynamic> args;

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments ?? {};

    interviewType.value = args['type'] ?? 'General Software Engineering';

    interviewMode.value = args['mode'] ?? 'chat';

    startInterview();
  }

  void startInterview() async {
    _aiService.startNewSession(
      interviewType: args['type'],
      experienceLevel: args['experience'] ?? '0-1 years',
      jobDescription: args['jobDescription'],
      techStack: args['techStack'] != null
          ? List<String>.from(args['techStack'])
          : null,
    );

    await getAIResponse(
      "Hello, I am ready for the interview.",
    );
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();

    if (text.isEmpty || isLoading.value) return;

    textController.clear();

    messages.add(
      MessageModel(
        sender: 'user',
        text: text,
        timestamp: DateTime.now(),
      ),
    );

    _scrollToBottom();

    await getAIResponse(text);
  }

  Future<void> getAIResponse(String userMessage) async {
    isLoading.value = true;
    isTyping.value = true;

    try {
      final response = await _aiService.sendMessage(userMessage);

      final data = json.decode(response);

      if (data['is_final'] == true) {
        isInterviewEnded.value = true;

        finalResult = InterviewResult(
          score: data['final_score'],
          strengths: List<String>.from(data['strengths']),
          weaknesses: List<String>.from(data['weaknesses']),
          suggestions: List<String>.from(data['suggestions']),
          nextTopics: List<String>.from(data['next_topics']),
        );

        messages.add(
          MessageModel(
            sender: 'ai',
            text:
                "Interview completed successfully. Click below to see detailed results.",
            timestamp: DateTime.now(),
          ),
        );

        _storageService.saveInterview(
          interviewType.value,
          data['final_score'],
          messages,
        );
      } else {
        questionCount.value++;

        String aiText = "";

        if (data['evaluation'] != null && data['evaluation'].isNotEmpty) {
          aiText += "${data['evaluation']}\n\n";
        }

        aiText += data['question'];

        messages.add(
          MessageModel(
            sender: 'ai',
            text: aiText,
            timestamp: DateTime.now(),
          ),
        );

        _voiceService.speak(data['question']);
      }
    } catch (e) {
      messages.add(
        MessageModel(
          sender: 'ai',
          text: "Something went wrong while generating response.",
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      isLoading.value = false;
      isTyping.value = false;

      _scrollToBottom();
    }
  }

  void startVoiceInput() {
    _voiceService.startListening(
      (text) {
        textController.text = text;
      },
    );

    isListening.value = true;
  }

  void stopVoiceInput() {
    _voiceService.stopListening();

    isListening.value = false;

    sendMessage();
  }

  void toggleTts() {
    _voiceService.toggleTts();
  }

  bool get isTtsEnabled => _voiceService.isTtsEnabled.value;

  void goToResults() {
    if (finalResult != null) {
      _voiceService.stopSpeaking();

      Get.toNamed(
        '/result',
        arguments: finalResult,
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  @override
  void onClose() {
    _voiceService.stopSpeaking();
    _voiceService.stopListening();

    textController.dispose();
    scrollController.dispose();

    super.onClose();
  }
}
