import 'package:get/get.dart';
import 'package:interview_ai/app/modules/history/history_binding.dart';
import 'package:interview_ai/app/modules/history/history_view.dart';
import '../modules/about/about_view.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/interview/interview_view.dart';
import '../modules/interview/interview_binding.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/result/result_view.dart';
import '../modules/result/result_binding.dart';

class AppPages {
  static const INITIAL = '/home';

  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/interview',
      page: () => const InterviewView(),
      binding: InterviewBinding(),
    ),
    GetPage(
      name: '/result',
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/history',
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(name: '/about', page: () => const AboutView()),
  ];
}
