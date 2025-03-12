import 'package:brandsinfo/presentation/screen/imagegallery/image_gallery.dart';
import 'package:brandsinfo/presentation/screen/splash/splash.dart';
import 'package:brandsinfo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrandsInfo',
      theme: AppThemes.lightTheme, // Set light theme
      darkTheme: AppThemes.darkTheme, // Set dark theme
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
