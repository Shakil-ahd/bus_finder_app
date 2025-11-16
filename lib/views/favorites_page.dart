import 'package:figma/widgets/app-bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../controllers/bus_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../widgets/bus_card.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FavoriteController favoriteController = Get.find();
  final BusController busController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          GradientAppBar(title: Text('favorites_title'.tr)),
      body: Obx(() {
        if (favoriteController.favoriteBuses.isEmpty) {
          return Center(
            child: Text(
              'no_favorites'.tr,
              style: TextStyle(
                  fontSize: 18,
                  color: context.theme.disabledColor),
            ),
          );
        }
        return ListView.builder(
          padding:
              const EdgeInsets.only(top: 12, bottom: 16),
          itemCount:
              favoriteController.favoriteBuses.length,
          itemBuilder: (context, index) {
            final bus =
                favoriteController.favoriteBuses[index];
            return BusCard(
              bus: bus,
              onTap: () => busController.selectBus(bus),
            );
          },
        );
      }),
    );
  }
}
