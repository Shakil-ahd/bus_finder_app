// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

// --- ❗️ সমাধান: 'Color'-এর বদলে 'MaterialColor' ---
const MaterialColor primaryColor = Colors.deepPurple;
// ---

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Bus App',
          debugShowCheckedModeBanner: false,

          // --- লাইট থিম ---
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: primaryColor,
            // ❗️ primarySwatch বাদ দেওয়া হয়েছে
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: primaryColor.withOpacity(0.05),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: primaryColor,
                ),
              ),
            ),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: Colors.grey[600],
                  elevation: 8.0,
                ),
          ),

          // --- ডার্ক থিম ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            // ❗️ এখন এটি সঠিকভাবে কাজ করবে
            primaryColor: primaryColor[300],
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(
              0xFF121212,
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.grey[100],
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                // ❗️ এখন এটিও সঠিকভাবে কাজ করবে
                borderSide: BorderSide(
                  color: primaryColor[300]!,
                ),
              ),
            ),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(
                  backgroundColor: const Color(0xFF1E1E1E),
                  selectedItemColor: primaryColor[300],
                  unselectedItemColor: Colors.grey[500],
                  elevation: 8.0,
                ),
          ),

          themeMode: mode,
          home: MainScreen(themeNotifier: themeNotifier),
        );
      },
    );
  }
}
