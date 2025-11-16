import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/route_finder_service.dart';
import 'bus_controller.dart';

class RouteController extends GetxController {
  final BusController _busController = Get.find();
  late RouteFinderService _routeFinderService;

  var fromController = TextEditingController().obs;
  var toController = TextEditingController().obs;

  var routeResult = Rxn<RouteResult>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _routeFinderService =
        RouteFinderService(_busController.allBuses);

    ever(_busController.allBuses, (allBuses) {
      _routeFinderService = RouteFinderService(allBuses);
    });
  }

  void findRoute() {
    isLoading(true);
    routeResult.value = null;

    final from = fromController.value.text;
    final to = toController.value.text;

    final result = _routeFinderService.findRoute(from, to);
    routeResult.value = result;
    isLoading(false);
  }
}
