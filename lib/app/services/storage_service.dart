import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/interview_model.dart';

class StorageService extends GetxService {
  final GetStorage _storage = GetStorage();

  static const String _historyKey = "interview_history";
  static const String _profileKey = "user_profile";

  /// INIT
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // INTERVIEW HISTORY
  void saveInterview(
    String type,
    int score,
    List<MessageModel> messages,
  ) {
    final List<dynamic> history = _storage.read(_historyKey) ?? [];

    final newEntry = {
      "type": type,
      "score": score,
      "date": DateTime.now().toIso8601String(),
      "messages": messages.map((e) => e.toMap()).toList(),
    };

    history.add(newEntry);
    _storage.write(_historyKey, history);
  }

  List<Map<String, dynamic>> getHistory() {
    final data = _storage.read(_historyKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(data);
  }

  void clearHistory() {
    _storage.remove(_historyKey);
  }

  //  PROFILE STORAGE
  void saveProfile(Map<String, dynamic> profile) {
    _storage.write(_profileKey, profile);
  }

  Map<String, dynamic>? getProfile() {
    final data = _storage.read(_profileKey);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  void clearProfile() {
    _storage.remove(_profileKey);
  }

  bool hasProfile() {
    final profile = getProfile();
    return profile != null && profile.isNotEmpty;
  }
}
