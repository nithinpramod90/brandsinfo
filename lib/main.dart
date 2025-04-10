import 'package:brandsinfo/firebase_options.dart';
import 'package:brandsinfo/presentation/screen/splash/splash.dart';
import 'package:brandsinfo/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: true, // Enable preview mode
  //     builder: (context) => const MyApp(), // Your main app widget
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // useInheritedMediaQuery: true, // Required for DevicePreview
      // locale: DevicePreview.locale(context), // Locale support
      // builder: DevicePreview.appBuilder, // Required for device frame
      debugShowCheckedModeBanner: false,
      title: 'BrandsInfo',
      theme: AppThemes.lightTheme, // Set light theme
      darkTheme: AppThemes.darkTheme, // Set dark theme
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
