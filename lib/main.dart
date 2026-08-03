import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:interview_ai/constants/constants.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'app/services/ai_service.dart';
import 'app/services/storage_service.dart';
import 'app/services/voice_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<AIService>(() => AIService().init());
  await Get.putAsync<VoiceService>(() => VoiceService().init());
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
    );
  }
}
