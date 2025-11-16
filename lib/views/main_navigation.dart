import 'package:figma/views/favorites_page.dart';
import 'package:figma/views/home_screen.dart';
import 'package:figma/views/search_screen.dart';
import 'package:figma/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigation extends StatelessWidget {
  MainNavigation({super.key});

  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: _selectedIndex.value,
            children: _screens,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: 'tab_home'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search_outlined),
                activeIcon: const Icon(Icons.search),
                label: 'tab_search'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border),
                activeIcon: const Icon(Icons.favorite),
                label: 'tab_favorites'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: 'tab_settings'.tr,
              ),
            ],
            currentIndex: _selectedIndex.value,
            onTap: _onItemTapped,
          )),
    );
  }
}
