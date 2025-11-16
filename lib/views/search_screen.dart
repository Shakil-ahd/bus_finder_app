import 'package:figma/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bus_controller.dart';
import '../../controllers/route_controller.dart';
import '../../services/route_finder_service.dart';

import '../constants/colors/app_colors.dart';
import '../widgets/bus_card.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final RouteController controller =
      Get.put(RouteController());
  final BusController busController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text('search_route_title'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchCard(context),
            const SizedBox(height: 24),
            Obx(() => _buildResultView()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.fromController.value,
            decoration: InputDecoration(
              labelText: 'from_location'.tr,
              prefixIcon: const Icon(Icons.my_location,
                  color: AppColors.gradientPink),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.toController.value,
            decoration: InputDecoration(
              labelText: 'to_location'.tr,
              prefixIcon: const Icon(Icons.location_on,
                  color: AppColors.gradientPurple),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              controller.findRoute();
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  'find_route_button'.tr,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultView() {
    if (controller.isLoading.isTrue) {
      return const Center(
          child: CircularProgressIndicator());
    }

    final result = controller.routeResult.value;

    if (result == null) {
      return const SizedBox.shrink();
    }

    if (result is NoRouteFound) {
      return Center(
        child: Text(
          'no_route_found'.tr,
          style: TextStyle(
              fontSize: 16, color: Get.theme.disabledColor),
        ),
      );
    }

    if (result is DirectRoute) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('direct_route'.tr,
              style: Get.context!.textTheme.titleLarge
                  ?.copyWith(
                      color: AppColors.gradientPurple)),
          const SizedBox(height: 8),
          BusCard(
            bus: result.bus,
            onTap: () =>
                busController.selectBus(result.bus),
          ),
        ],
      );
    }

    if (result is TransferRoute) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('transfer_route'.tr,
              style: Get.context!.textTheme.titleLarge
                  ?.copyWith(
                      color: AppColors.gradientPink)),
          const SizedBox(height: 12),
          Text('take_bus'.tr,
              style: Get.context!.textTheme.titleMedium),
          BusCard(
            bus: result.busA,
            onTap: () =>
                busController.selectBus(result.busA),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.arrow_downward,
                    color: Get.theme.colorScheme
                        .onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${'get_down_at'.tr} ${result.junctionStop}',
                    style: Get
                        .context!.textTheme.titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Text('then_take_bus'.tr,
              style: Get.context!.textTheme.titleMedium),
          BusCard(
            bus: result.busB,
            onTap: () =>
                busController.selectBus(result.busB),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
