import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TodoApp());
}

/// Root widget of the Todo application.
/// Configures Material 3, executive dark theme with radiant gold accents.
class TodoApp extends StatelessWidget {
  final Widget? home;

  const TodoApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow - Todo List (Assignment 5)',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14), // Obsidian dark canvas
        canvasColor: const Color(0xFF0B0E14),
        cardColor: const Color(0xFF151A22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37), // Royal Gold
          secondary: Color(0xFFE2C974), // Soft Gold
          surface: Color(0xFF151A22), // Elevated surface
          onPrimary: Color(0xFF0F131A),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0E14),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFD4AF37);
            }
            return Colors.transparent;
          }),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14), // Obsidian dark canvas
        canvasColor: const Color(0xFF0B0E14),
        cardColor: const Color(0xFF151A22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37), // Royal Gold
          secondary: Color(0xFFE2C974), // Soft Gold
          surface: Color(0xFF151A22), // Elevated surface
          onPrimary: Color(0xFF0F131A),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0E14),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFD4AF37);
            }
            return Colors.transparent;
          }),
        ),
      ),
      home: home ?? const SplashScreen(),
    );
  }
}
