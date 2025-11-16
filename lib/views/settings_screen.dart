import 'package:figma/controllers/settings_conroller.dart';
import 'package:figma/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller =
      Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          GradientAppBar(title: Text('settings_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLanguageCard(context),
          const SizedBox(height: 20),
          _buildThemeCard(context),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      color: context.theme.cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Center(
                child: ToggleButtons(
                  isSelected: [
                    controller.isBangla.value,
                    !controller.isBangla.value,
                  ],
                  onPressed: (index) {
                    controller.toggleLanguage(index == 0);
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: context.theme.primaryColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0),
                      child: Text('bangla'.tr),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0),
                      child: Text('english'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      color: context.theme.cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'theme'.tr,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Center(
                child: ToggleButtons(
                  isSelected: [
                    !controller.isDarkMode.value,
                    controller.isDarkMode.value,
                  ],
                  onPressed: (index) {
                    controller.toggleTheme(index == 1);
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: context.theme.primaryColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                              Icons.wb_sunny_outlined),
                          const SizedBox(width: 8),
                          Text('light_mode'.tr),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                              Icons.nightlight_outlined),
                          const SizedBox(width: 8),
                          Text('dark_mode'.tr),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
