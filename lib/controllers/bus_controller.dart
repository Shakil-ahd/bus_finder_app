import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/bus_data.dart';
import '../main.dart';
import '../models/bus_model.dart';

class BusController extends GetxController {
  var isLoading = true.obs;
  var isSeeding = false.obs;
  var allBuses = <BusModel>[].obs;
  var foundBuses = <BusModel>[].obs;
  var selectedBus = Rxn<BusModel>();
  var searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      isLoading(true);
      await _seedDataToSupabase();
      await fetchBuses();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'load_error'.tr}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> _seedDataToSupabase() async {
    try {
      final response = await supabase
          .from('buses')
          .select('id')
          .limit(1)
          .maybeSingle();

      if (response == null) {
        isSeeding(true);
        Get.snackbar(
          'database_setup'.tr,
          'seeding_data'.trParams(
              {'count': localBusList.length.toString()}),
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );

        final List<Map<String, dynamic>> jsonDataList =
            localBusList
                .map((bus) => bus.toJson())
                .toList();

        await supabase.from('buses').insert(jsonDataList);

        isSeeding(false);
        Get.snackbar(
          'success'.tr,
          'seeding_success'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isSeeding(false);
      Get.snackbar(
        'error'.tr,
        '${'seeding_error'.tr}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchBuses() async {
    try {
      isLoading(true);
      final List<dynamic> response = await supabase
          .from('buses')
          .select()
          .order('nameEn', ascending: true);

      if (response.isNotEmpty) {
        allBuses.value = response
            .map((data) => BusModel.fromJson(data))
            .toList();
        foundBuses.value = allBuses;
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'load_error'.tr}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void runFilter(String keyword) {
    searchKeyword.value = keyword;
    if (keyword.isEmpty) {
      foundBuses.value = allBuses;
    } else {
      final String lowerKeyword = keyword.toLowerCase();
      foundBuses.value = allBuses.where((bus) {
        return bus.nameEn
                .toLowerCase()
                .contains(lowerKeyword) ||
            bus.nameBn.contains(keyword) ||
            bus.fromEn
                .toLowerCase()
                .contains(lowerKeyword) ||
            bus.fromBn.contains(keyword) ||
            bus.toEn.toLowerCase().contains(lowerKeyword) ||
            bus.toBn.contains(keyword) ||
            bus.stoppagesEn.any((stop) => stop
                .toLowerCase()
                .contains(lowerKeyword)) ||
            bus.stoppagesBn
                .any((stop) => stop.contains(keyword));
      }).toList();
    }
  }

  void selectBus(BusModel bus) {
    selectedBus.value = bus;
    Get.toNamed('/details');
  }
}
