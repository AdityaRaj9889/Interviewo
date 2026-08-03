import 'package:get/get.dart';
import '../../models/interview_model.dart';

class ResultController extends GetxController {
  late InterviewResult result;

  @override
  void onInit() {
    super.onInit();
    result = Get.arguments;
  }

  void goHome() {
    Get.offAllNamed('/home');
  }
}
