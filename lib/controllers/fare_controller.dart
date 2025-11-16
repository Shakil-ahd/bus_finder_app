// lib/controllers/fare_controller.dart
import 'package:figma/controllers/settings_conroller.dart';
import 'package:get/get.dart';
import '../models/bus_model.dart';

class FareController extends GetxController {
  final BusModel bus;
  final SettingsController _settingsController = Get.find();

  // Selected values (display names)
  final fromStop = RxnString();
  final toStop = RxnString();
  final calculatedFare = 0.obs;

  // Display stops (reactive)
  final allStops = <String>[].obs;

  // Index maps for quick lookup
  final Map<String, int> stopIndexMapEn = {};
  final Map<String, int> stopIndexMapBn = {};

  // Internal tracking of selected stops using their index
  final selectedFromIndex = RxnInt();
  final selectedToIndex = RxnInt();

  FareController(this.bus);

  @override
  void onInit() {
    super.onInit();
    _initializeStops();
    ever(_settingsController.isBangla,
        (_) => _updateDisplayStops());
  }

  void _initializeStops() {
    final enStops = [
      bus.fromEn,
      ...bus.stoppagesEn,
      bus.toEn
    ];
    final bnStops = [
      bus.fromBn,
      ...bus.stoppagesBn,
      bus.toBn
    ];

    // Build index maps
    for (int i = 0; i < enStops.length; i++) {
      if (enStops[i].isNotEmpty)
        stopIndexMapEn[enStops[i]] = i;
      if (bnStops[i].isNotEmpty)
        stopIndexMapBn[bnStops[i]] = i;
    }

    _updateDisplayStops();
  }

  void _updateDisplayStops() {
    final enStops = [
      bus.fromEn,
      ...bus.stoppagesEn,
      bus.toEn
    ];
    final bnStops = [
      bus.fromBn,
      ...bus.stoppagesBn,
      bus.toBn
    ];

    if (_settingsController.isBangla.value) {
      allStops.assignAll(bnStops);
      fromStop.value = selectedFromIndex.value != null
          ? bnStops[selectedFromIndex.value!]
          : null;
      toStop.value = selectedToIndex.value != null
          ? bnStops[selectedToIndex.value!]
          : null;
    } else {
      allStops.assignAll(enStops);
      fromStop.value = selectedFromIndex.value != null
          ? enStops[selectedFromIndex.value!]
          : null;
      toStop.value = selectedToIndex.value != null
          ? enStops[selectedToIndex.value!]
          : null;
    }
    calculateFare();
  }

  void setFromStop(String? value) {
    fromStop.value = value;
    selectedFromIndex.value = value != null
        ? (_settingsController.isBangla.value
            ? stopIndexMapBn[value]
            : stopIndexMapEn[value])
        : null;
    calculateFare();
  }

  void setToStop(String? value) {
    toStop.value = value;
    selectedToIndex.value = value != null
        ? (_settingsController.isBangla.value
            ? stopIndexMapBn[value]
            : stopIndexMapEn[value])
        : null;
    calculateFare();
  }

  void calculateFare() {
    if (selectedFromIndex.value == null ||
        selectedToIndex.value == null) {
      calculatedFare.value = 0;
      return;
    }
    if (selectedFromIndex.value == selectedToIndex.value) {
      calculatedFare.value = -1;
      return;
    }

    final fromIndex = selectedFromIndex.value!;
    final toIndex = selectedToIndex.value!;
    final stopCount = (fromIndex - toIndex).abs();

    const double estimatedKmPerStop = 1.5;
    final double estimatedKm =
        stopCount * estimatedKmPerStop;
    int fare = (estimatedKm * bus.farePerKm).ceil();

    if (fare < bus.minFare) fare = bus.minFare;
    calculatedFare.value = fare;
  }
}
