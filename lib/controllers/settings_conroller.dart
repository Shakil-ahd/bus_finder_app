import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _box = GetStorage();
  final _isDarkModeKey = 'isDarkMode';
  final _isBanglaKey = 'isBangla';

  var isDarkMode = false.obs;
  var isBangla = true.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _box.read(_isDarkModeKey) ?? false;
    isBangla.value = _box.read(_isBanglaKey) ?? true;
    _updateTheme();
    _updateLocale();
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    _box.write(_isDarkModeKey, isDark);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeThemeMode(isDarkMode.value
        ? ThemeMode.dark
        : ThemeMode.light);
  }

  void toggleLanguage(bool isBn) {
    isBangla.value = isBn;
    _box.write(_isBanglaKey, isBn);
    _updateLocale();
  }

  void _updateLocale() {
    Get.updateLocale(isBangla.value
        ? const Locale('bn', 'BD')
        : const Locale('en', 'US'));
  }
}
