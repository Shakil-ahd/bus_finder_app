import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/bus_model.dart';
import 'bus_controller.dart';

class FavoriteController extends GetxController {
  var favoriteBuses = <BusModel>[].obs;
  final _box = GetStorage();
  final _storageKey = 'favoriteBuses';
  final BusController _busController = Get.find();

  @override
  void onInit() {
    super.onInit();
    ever(_busController.allBuses, (_) => _loadFavorites());
  }

  void _loadFavorites() {
    List<dynamic>? favoriteBusNames =
        _box.read<List<dynamic>>(_storageKey);
    if (favoriteBusNames != null) {
      favoriteBuses.value = _busController.allBuses
          .where((bus) =>
              favoriteBusNames.contains(bus.nameEn))
          .toList();
    }
  }

  bool isFavorite(BusModel bus) {
    return favoriteBuses.any((b) => b.nameEn == bus.nameEn);
  }

  void toggleFavorite(BusModel bus) {
    if (isFavorite(bus)) {
      favoriteBuses
          .removeWhere((b) => b.nameEn == bus.nameEn);
    } else {
      favoriteBuses.add(bus);
    }
    _saveFavorites();
  }

  void _saveFavorites() {
    List<String> favoriteBusNames =
        favoriteBuses.map((bus) => bus.nameEn).toList();
    _box.write(_storageKey, favoriteBusNames);
  }

  void syncFavoritesWithAllBuses() {}
}
