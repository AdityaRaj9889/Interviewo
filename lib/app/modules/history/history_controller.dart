import 'package:get/get.dart';
import '../../services/storage_service.dart';

class HistoryController extends GetxController {
  final StorageService storage = Get.find<StorageService>();

  /// ALL HISTORY DATA
  var historyList = <Map<String, dynamic>>[].obs;

  /// SCORES ONLY (for chart)
  var scores = <int>[].obs;

  /// LOADING STATE (future proof)
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  /// LOAD HISTORY
  void loadHistory() {
    isLoading.value = true;

    final data = storage.getHistory();

    /// newest first (important for UX)
    final reversed = data.reversed.toList();

    historyList.value = reversed;

    /// extract scores for chart
    scores.value = reversed.map<int>((e) => (e['score'] ?? 0) as int).toList();

    isLoading.value = false;
  }

  /// REFRESH
  void refreshHistory() {
    loadHistory();
  }

  /// CLEAR
  void clearHistory() {
    storage.clearHistory();
    historyList.clear();
    scores.clear();
  }

  /// ANALYTICS

  double get averageScore {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  int get bestScore {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a > b ? a : b);
  }

  int get totalInterviews => historyList.length;

  /// FILTER BY TYPE
  List<Map<String, dynamic>> filterByType(String type) {
    return historyList.where((e) => e['type'] == type).toList();
  }

  /// BADGE
  String getBadge(int score) {
    if (score >= 90) return "Expert 🥇";
    if (score >= 75) return "Strong 🥈";
    if (score >= 50) return "Improving 🥉";
    return "Beginner 🔄";
  }
}
