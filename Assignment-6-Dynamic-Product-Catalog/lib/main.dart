import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const LuxeMartApp());
}

/// Root widget for the LUXE MART mobile application.
/// Configures Material 3 theme and starts at the SplashScreen.
class LuxeMartApp extends StatelessWidget {
  const LuxeMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUXE MART',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
