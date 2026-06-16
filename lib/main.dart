// ignore_for_file: prefer_const_constructors

import 'package:figma/constants/supabase_credential.dart';
import 'package:figma/controllers/settings_conroller.dart';
import 'package:figma/localization/app_translation.dart';
import 'package:figma/views/bus_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/colors/app_colors.dart';

import 'controllers/bus_controller.dart';
import 'controllers/favorite_controller.dart';

import 'controllers/route_controller.dart';

import 'views/main_navigation.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: YOUR_SUPABASE_URL,
    anonKey: YOUR_SUPABASE_ANON_KEY,
  );

  await GetStorage.init();

  Get.put(SettingsController(), permanent: true);
  Get.put(BusController(), permanent: true);
  Get.put(FavoriteController(), permanent: true);
  Get.put(RouteController(), permanent: true);

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find();
    const textTheme = TextTheme(
      headlineSmall: TextStyle(fontSize: 20),
      titleLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
    );

    return GetMaterialApp(
      title: 'Dhaka Bus Finder',
      debugShowCheckedModeBanner: false,


      translations: AppTranslations(),
      locale: settingsController.isBangla.value
          ? const Locale('bn', 'BD')
          : const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.gradientPurple,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        cardColor: AppColors.cardLight,
        fontFamily: 'Roboto',
        disabledColor: AppColors.placeholderTextLight,
        textTheme: textTheme.copyWith(
          titleLarge: textTheme.titleLarge
              ?.copyWith(color: AppColors.primaryTextLight),
          titleMedium: textTheme.titleMedium
              ?.copyWith(color: AppColors.primaryTextLight),
          bodyMedium: textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryTextLight),
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.gradientPurple,
          unselectedItemColor:
              AppColors.placeholderTextLight,
          elevation: 4,
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          borderColor: AppColors.gradientPurple,
          color: AppColors.gradientPurple,
          selectedBorderColor: AppColors.gradientPurple,
          selectedColor: Colors.white,
          fillColor: AppColors.gradientPurple,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.gradientPink,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.cardDark,
        fontFamily: 'Roboto',
        disabledColor: AppColors.placeholderTextDark,
        textTheme: textTheme.copyWith(
          titleLarge: textTheme.titleLarge
              ?.copyWith(color: AppColors.primaryTextDark),
          titleMedium: textTheme.titleMedium
              ?.copyWith(color: AppColors.primaryTextDark),
          bodyMedium: textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryTextDark),
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          backgroundColor: AppColors.cardDark,
          selectedItemColor: AppColors.gradientPink,
          unselectedItemColor:
              AppColors.placeholderTextDark,
          elevation: 4,
        ),
        toggleButtonsTheme: const ToggleButtonsThemeData(
          borderColor: AppColors.gradientPink,
          color: AppColors.gradientPink,
          selectedBorderColor: AppColors.gradientPink,
          selectedColor: Colors.white,
          fillColor: AppColors.gradientPink,
        ),
      ),

      themeMode: settingsController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,

      initialRoute: '/splash',
      getPages: [
        GetPage(
            name: '/splash',
            page: () => const SplashScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/home',
            page: () => MainNavigation(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/details',
            page: () => DetailsScreen(),
            transition: Transition.rightToLeftWithFade),
      ],
    );
  }
}
