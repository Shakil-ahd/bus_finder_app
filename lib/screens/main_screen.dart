// lib/screens/main_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ❗️সঠিক import পাথ
import '../services/favorite_service.dart';
import 'search_page.dart';
import 'favorites_page.dart';
import 'all_routes_page.dart';

class MainScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  const MainScreen({
    super.key,
    required this.themeNotifier,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isEnglish = true;
  final FavoriteService _favoriteService =
      FavoriteService();
  bool _isLoading = true;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  // অ্যাপ শুরু হওয়ার আগে ফেভারিট লিস্ট লোড করবে
  Future<void> _initApp() async {
    await _favoriteService.init();

    // পেজ লিস্টটি সার্ভিস লোড হওয়ার *পরে* তৈরি করুন
    _buildPages();

    setState(() {
      _isLoading = false;
    });
  }

  // পেজ লিস্ট তৈরি করার ফাংশন
  void _buildPages() {
    _pages = [
      SearchPage(
        isBangla: !isEnglish,
        favoriteService: _favoriteService,
      ),
      FavoritesPage(
        isBangla: !isEnglish,
        favoriteService: _favoriteService,
      ),
      AllRoutesPage(isBangla: !isEnglish),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
      // ভাষা বদল হলে পেজগুলোকেও নতুন ভাষা জানিয়ে রিবিল্ড করতে হবে
      _buildPages();
    });
  }

  String _getTitle() {
    if (_selectedIndex == 0)
      return isEnglish ? 'Search Buses' : 'বাস খুঁজুন';
    if (_selectedIndex == 1)
      return isEnglish ? 'Favorites' : 'প্রিয় তালিকা';
    return isEnglish ? 'All Routes' : 'সব রুট';
  }

  @override
  Widget build(BuildContext context) {
    // ❗️ Gradient-এর জন্য থিমের কালার অ্যাক্সেস করা
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),

        // --- ❗️ Gradient কোড ---
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(
                  0.7,
                ), // প্রাইমারি কালারের শেড
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // --- ❗️ Gradient কোড শেষ ---
        actions: [
          IconButton(
            icon: Icon(
              widget.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              widget.themeNotifier.value =
                  widget.themeNotifier.value ==
                      ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search), // iOS আইকন
            label: isEnglish ? 'Search' : 'খুঁজুন',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.heart_fill,
            ), // iOS আইকন
            label: isEnglish ? 'Favorites' : 'প্রিয়',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.map_pin_ellipse,
            ), // iOS আইকন
            label: isEnglish ? 'Routes' : 'রুট',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
