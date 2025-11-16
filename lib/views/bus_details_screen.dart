// lib/screens/details_screen.dart
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
    bus = busController.selectedBus.value!;
    fareController = Get.put(FareController(bus));
  }

  @override
  void dispose() {
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
        title: Obx(() => Text(
              settingsController.isBangla.value
                  ? bus.nameBn
                  : bus.nameEn,
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            )),
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
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildFareCalculatorCard(),
            const SizedBox(height: 24),
            Text(
              'stoppages_bangla'.tr,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildStoppageCard(
                bus.stoppagesBn, AppColors.primaryGradient),
            const SizedBox(height: 24),
            Text(
              'stoppages_english'.tr,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildStoppageCard(bus.stoppagesEn,
                AppColors.primaryGradientReversed),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
              offset: const Offset(0, 4)),
        ],
      ),
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
    );
  }

  Widget _buildStoppageCard(
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
              offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: stoppages
            .map((stop) => StoppageChip(
                label: stop, gradient: gradient))
            .toList(),
      ),
    );
  }

  Widget _buildFareCalculatorCard() {
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
              offset: const Offset(0, 4)),
        ],
      ),
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

          // From Stop
          Obx(() => DropdownButtonFormField<String>(
                value: fareController
                        .fromStop.value!.isNotEmpty
                    ? fareController.fromStop.value
                    : null,
                hint: Text('select_starting_stop'.tr),
                isExpanded: true,
                items: fareController.allStops
                    .map((stop) => DropdownMenuItem(
                        value: stop, child: Text(stop)))
                    .toList(),
                onChanged: (value) =>
                    fareController.setFromStop(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.my_location,
                      color: AppColors.gradientPink),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8)),
                ),
              )),

          const SizedBox(height: 16),

          // To Stop
          Obx(() => DropdownButtonFormField<String>(
                value:
                    fareController.toStop.value!.isNotEmpty
                        ? fareController.toStop.value
                        : null,
                hint: Text('select_destination_stop'.tr),
                isExpanded: true,
                items: fareController.allStops
                    .map((stop) => DropdownMenuItem(
                        value: stop, child: Text(stop)))
                    .toList(),
                onChanged: (value) =>
                    fareController.setToStop(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on,
                      color: AppColors.gradientPurple),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8)),
                ),
              )),

          const SizedBox(height: 16),

          // Fare Result
          Obx(() {
            if (fareController.calculatedFare.value == 0)
              return const SizedBox.shrink();
            if (fareController.calculatedFare.value == -1) {
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
                      'fare': fareController
                          .calculatedFare.value
                          .toString()
                    }),
                    style: context.textTheme.headlineSmall
                        ?.copyWith(
                            fontWeight: FontWeight.bold),
                  ),
                  if (fareController.calculatedFare.value ==
                      bus.minFare)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'min_fare_warning'.trParams({
                          'fare': bus.minFare.toString()
                        }),
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
