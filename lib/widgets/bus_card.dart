import 'package:figma/constants/colors/app_colors.dart';
import 'package:figma/controllers/settings_conroller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../models/bus_model.dart';
import '../../controllers/favorite_controller.dart';

class BusCard extends StatelessWidget {
  final BusModel bus;
  final VoidCallback onTap;

  BusCard({
    super.key,
    required this.bus,
    required this.onTap,
  });

  final FavoriteController favoriteController = Get.find();
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: context.isDarkMode
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_bus,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            settingsController
                                    .isBangla.value
                                ? bus.nameBn
                                : bus.nameEn,
                            style: context
                                .textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.gradientPink,
                            ),
                          )),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            settingsController
                                    .isBangla.value
                                ? '${bus.fromBn} - ${bus.toBn}'
                                : '${bus.fromEn} - ${bus.toEn}',
                            style: context
                                .textTheme.bodyMedium
                                ?.copyWith(
                                    color: context
                                        .theme
                                        .colorScheme
                                        .onSurfaceVariant),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                ),
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
                          : Colors.grey,
                    ),
                    onPressed: () {
                      favoriteController
                          .toggleFavorite(bus);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
