// lib/main.dart
import 'package:figma/services/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/search_page.dart';
import 'screens/all_routes_page.dart';
import 'screens/favorites_page.dart';
import 'services/favorite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final favoriteService = FavoriteService(prefs);
  await favoriteService.init();

  runApp(MyApp(favoriteService: favoriteService));
}

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

class MyApp extends StatefulWidget {
  final FavoriteService favoriteService;

  const MyApp({super.key, required this.favoriteService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isBangla = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleLanguage(bool value) {
    setState(() {
      _isBangla = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SearchPage(
        isBangla: _isBangla,
        favoriteService: widget.favoriteService,
      ),
      AllRoutesPage(
        isBangla: _isBangla,
        favoriteService: widget.favoriteService,
      ),
      FavoritesPage(
        isBangla: _isBangla,
        favoriteService: widget.favoriteService,
      ),
    ];

    final List<String> pageTitles = _isBangla
        ? ['অনুসন্ধান', 'সব রুট', 'প্রিয় তালিকা']
        : ['Search', 'All Routes', 'Favorites'];

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bus Route Finder',

          // --- লাইট থিম ---
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(
              0xFFDA70D6,
            ), // Orchid Pink
            colorScheme:
                ColorScheme.fromSwatch(
                  primarySwatch: Colors.deepPurple,
                ).copyWith(
                  secondary: const Color(
                    0xFF87CEEB,
                  ), // Light Sky Blue
                  primary: const Color(0xFFDA70D6),
                ),
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
            ),
            // --- ❗️ সমাধান: CardThemeData ---
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white.withOpacity(
                0.85,
              ), // withOpacity এখানে ঠিক আছে
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Color(0xFFDA70D6),
                  width: 2,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFDA70D6,
                ), // Orchid Pink
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(
                  backgroundColor: Colors.white.withOpacity(
                    0.9,
                  ),
                  selectedItemColor: const Color(
                    0xFFDA70D6,
                  ),
                  unselectedItemColor: Colors.grey[600],
                ),
          ),

          // --- ডার্ক থিম ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFFDA70D6),
            colorScheme:
                ColorScheme.fromSwatch(
                  primarySwatch: Colors.deepPurple,
                  brightness: Brightness.dark,
                ).copyWith(
                  secondary: const Color(0xFF87CEEB),
                  primary: const Color(0xFFDA70D6),
                ),
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
            ),
            // --- ❗️ সমাধান: CardThemeData ---
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              // ❗️ Deprecated ওয়ার্নিং ঠিক করা হয়েছে (0.4 * 255 = 102 = 66 in hex)
              color: const Color(
                0x66000000,
              ), // Colors.black.withOpacity(0.4)
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Color(0xFFDA70D6),
                  width: 2,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDA70D6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(
                  backgroundColor: Colors.black.withOpacity(
                    0.8,
                  ),
                  selectedItemColor: const Color(
                    0xFFDA70D6,
                  ),
                  unselectedItemColor: Colors.grey[400],
                ),
          ),

          themeMode: mode,

          home: CustomScaffold(
            isBangla: _isBangla,
            onLanguageChanged: _toggleLanguage,
            title: pageTitles[_selectedIndex],
            body: pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.search),
                  label: _isBangla ? 'অনুসন্ধান' : 'Search',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.bus),
                  label: _isBangla
                      ? 'সব রুট'
                      : 'All Routes',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    CupertinoIcons.heart_fill,
                  ),
                  label: _isBangla ? 'প্রিয়' : 'Favorites',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
