import 'package:figma/constants/colors/app_colors.dart';
import 'package:figma/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bus_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../widgets/bus_card.dart';
import '../widgets/bus_list_shimmer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BusController busController = Get.find();
  final FavoriteController favoriteController = Get.find();
  final TextEditingController searchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (busController.allBuses.isNotEmpty) {
        favoriteController.syncFavoritesWithAllBuses();
      }
    });

    return Scaffold(
      appBar: GradientAppBar(title: Text('app_title'.tr)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) =>
                  busController.runFilter(value),
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.gradientPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0),
                suffixIcon: Obx(() => busController
                        .searchKeyword.value.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          busController.runFilter('');
                        },
                      )),
              ),
            ),
          ),
          Obx(() {
            if (busController.isLoading.isTrue) {
              return const BusListShimmer();
            }
            if (busController.foundBuses.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    busController.isSeeding.isTrue
                        ? '${'database_setup'.tr}\n${'loading'.tr}'
                        : 'no_bus_found'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: context.theme.disabledColor),
                  ),
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: busController.foundBuses.length,
                itemBuilder: (context, index) {
                  final bus =
                      busController.foundBuses[index];
                  return BusCard(
                    bus: bus,
                    onTap: () =>
                        busController.selectBus(bus),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
