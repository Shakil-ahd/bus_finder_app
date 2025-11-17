import 'package:figma/constants/colors/app_colors.dart';
import 'package:figma/controllers/settings_conroller.dart';
import 'package:figma/widgets/app-bar.dart';
import 'package:figma/widgets/stoppage_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bus_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/fare_controller.dart';

import '../models/bus_model.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() =>
      _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final BusController busController = Get.find();
  final FavoriteController favoriteController = Get.find();
  final SettingsController settingsController = Get.find();
  late FareController fareController;
  late BusModel bus;

  @override
  void initState() {
    super.initState();
    // Bus object এখানে সেফ
    bus = busController.selectedBus.value!;
    // FareController এখানে তৈরি করা হলো
    fareController = Get.put(FareController(bus));
  }

  @override
  void dispose() {
    // FareController পেজ বন্ধ হওয়ার সাথে সাথে মেমরি থেকে সরানো হলো
    Get.delete<FareController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (busController.selectedBus.value == null) {
      return Scaffold(
        appBar: GradientAppBar(title: Text('error'.tr)),
        body: Center(child: Text('no_bus_selected'.tr)),
      );
    }

    return Scaffold(
      appBar: GradientAppBar(
        // FIX: title এখন সরাসরি Widget গ্রহণ করে, তাই Obx ঠিকমতো কাজ করবে।
        title: Obx(() => Text(
            settingsController.isBangla.value
                ? bus.nameBn
                : bus.nameEn)),
        actions: [
          Obx(() {
            final isFav =
                favoriteController.isFavorite(bus);
            return IconButton(
              icon: Icon(
                isFav
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFav
                    ? AppColors.gradientRed
                    : Colors.white,
              ),
              onPressed: () =>
                  favoriteController.toggleFavorite(bus),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context, bus),
            const SizedBox(height: 24),
            _buildFareCalculatorCard(
                context, fareController, bus),
            const SizedBox(height: 24),

            // --- শুধুমাত্র একটি স্টপেজ লিস্ট ব্লক রাখা হলো ---
            Obx(() => Text(
                  settingsController.isBangla.value
                      ? 'stoppages_bangla'.tr
                      : 'stoppages_english'.tr,
                  style: context.textTheme.titleLarge
                      ?.copyWith(
                          fontWeight: FontWeight.w600),
                )),
            const SizedBox(height: 10),
            Obx(
              () => _buildStoppageCard(
                context,
                settingsController.isBangla.value
                    ? bus.stoppagesBn
                    : bus.stoppagesEn,
                AppColors.primaryGradient,
              ),
            ),
            // --- আগের ইংরেজি স্টপেজ ব্লক সরানো হয়েছে ---
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, BusModel bus) {
    // FIX: context.isDarkMode এর বদলে Get.isDarkMode ব্যবহার করা হলো
    final isDarkMode = Get.isDarkMode;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppColors.cardGradientDark
            : AppColors.cardGradientLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  settingsController.isBangla.value
                      ? bus.nameBn
                      : bus.nameEn,
                  style: context.textTheme.headlineSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gradientPink,
                  ),
                )),
            const Divider(height: 24),
            Obx(() => Text(
                  '${'from'.tr}: ${settingsController.isBangla.value ? bus.fromBn : bus.fromEn}',
                  style: context.textTheme.titleMedium,
                )),
            const SizedBox(height: 4),
            Obx(() => Text(
                  '${'to'.tr}: ${settingsController.isBangla.value ? bus.toBn : bus.toEn}',
                  style: context.textTheme.titleMedium,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStoppageCard(BuildContext context,
      List<String> stoppages, Gradient gradient) {
    final isDarkMode = Get.isDarkMode;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppColors.cardGradientDark
            : AppColors.cardGradientLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: stoppages
              .map((stop) => StoppageChip(
                  label: stop, gradient: gradient))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFareCalculatorCard(BuildContext context,
      FareController controller, BusModel bus) {
    final isDarkMode = Get.isDarkMode;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppColors.cardGradientDark
            : AppColors.cardGradientLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'fare_calculator'.tr,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.fromStop.value,
                hint: Text('select_starting_stop'.tr),
                isExpanded: true,
                items: controller.allStops
                    .map((stop) => DropdownMenuItem(
                          value: stop,
                          child: Text(stop),
                        ))
                    .toList(),
                onChanged: (value) =>
                    controller.setFromStop(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.my_location,
                      color: AppColors.gradientPink),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.toStop.value,
                hint: Text('select_destination_stop'.tr),
                isExpanded: true,
                items: controller.allStops
                    .map((stop) => DropdownMenuItem(
                          value: stop,
                          child: Text(stop),
                        ))
                    .toList(),
                onChanged: (value) =>
                    controller.setToStop(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on,
                      color: AppColors.gradientPurple),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.calculatedFare.value == 0) {
                return const SizedBox.shrink();
              }
              if (controller.calculatedFare.value == -1) {
                return Center(
                  child: Text(
                    'select_different_stops'.tr,
                    style: const TextStyle(
                        color: AppColors.gradientRed,
                        fontSize: 16),
                  ),
                );
              }
              return Center(
                child: Column(
                  children: [
                    Text(
                      'estimated_fare'.trParams({
                        'fare': controller
                            .calculatedFare.value
                            .toString()
                      }),
                      style: context.textTheme.headlineSmall
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.calculatedFare.value ==
                        bus.minFare)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'min_fare_warning'.trParams({
                            'fare': bus.minFare.toString()
                          }),
                          style:
                              context.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
