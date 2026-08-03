import 'package:get/get.dart';
import 'interview_controller.dart';

class InterviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewController>(() => InterviewController());
  }
}
