import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService extends GetxService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();

  final isListening = false.obs;
  final speechText = "".obs;
  final isTtsEnabled = true.obs;

  Future<VoiceService> init() async {
    await _initTts();
    await _initStt();
    return this;
  }

  Future<void> _initTts() async {
    try {
      // Android uses Google TTS engine
      if (Platform.isAndroid) {
        await _tts.setEngine("com.google.android.tts");
      }

      await _tts.setLanguage("en-US");

      // More natural values
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.05);
      await _tts.setVolume(1.0);

      await _tts.awaitSpeakCompletion(true);

      // Print all available voices
      final voices = await _tts.getVoices;

      if (voices != null) {
        print("Available voices:");
        print(voices);

        // Try to select a high-quality English voice
        for (final voice in voices) {
          final locale = voice["locale"]?.toString().toLowerCase() ?? "";

          if (locale.contains("en-us")) {
            await _tts.setVoice({
              "name": voice["name"],
              "locale": voice["locale"],
            });

            print("Selected Voice: ${voice["name"]}");
            break;
          }
        }
      }

      _tts.setStartHandler(() {
        print("TTS Started");
      });

      _tts.setCompletionHandler(() {
        print("TTS Completed");
      });

      _tts.setErrorHandler((message) {
        print("TTS Error: $message");
      });
    } catch (e) {
      print("TTS Init Error: $e");
    }
  }

  Future<void> _initStt() async {
    try {
      await _stt.initialize();
    } catch (e) {
      print("STT Init Error: $e");
    }
  }

  Future<void> speak(String text) async {
    if (!isTtsEnabled.value) return;

    try {
      // Stop previous speech
      await _tts.stop();

      // Add pauses for more natural speaking
      final naturalText = text
          .replaceAll(".", ". ")
          .replaceAll("?", "? ")
          .replaceAll("!", "! ");

      await _tts.speak(naturalText);
    } catch (e) {
      print("Speak Error: $e");
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> startListening(
    Function(String) onResult,
  ) async {
    try {
      var status = await Permission.microphone.status;

      if (status.isDenied) {
        status = await Permission.microphone.request();
      }

      if (!status.isGranted) {
        Get.snackbar(
          "Permission Required",
          "Microphone permission is required for voice input.",
        );
        return;
      }

      isListening.value = true;

      await _stt.listen(
        onResult: (result) {
          speechText.value = result.recognizedWords;
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        cancelOnError: true,
      );
    } catch (e) {
      print("Start Listening Error: $e");
    }
  }

  Future<void> stopListening() async {
    try {
      isListening.value = false;
      await _stt.stop();
    } catch (_) {}
  }

  void toggleTts() {
    isTtsEnabled.value = !isTtsEnabled.value;

    if (!isTtsEnabled.value) {
      stopSpeaking();
    }
  }
}
