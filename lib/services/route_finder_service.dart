import 'package:figma/controllers/settings_conroller.dart';

import '../models/bus_model.dart';
import 'package:get/get.dart';

abstract class RouteResult {}

class DirectRoute extends RouteResult {
  final BusModel bus;
  DirectRoute(this.bus);
}

class TransferRoute extends RouteResult {
  final BusModel busA;
  final BusModel busB;
  final String junctionStop;
  TransferRoute(this.busA, this.busB, this.junctionStop);
}

class NoRouteFound extends RouteResult {}

class RouteFinderService {
  final List<BusModel> _allBuses;
  final SettingsController _settingsController = Get.find();
  bool _isBangla = false;

  RouteFinderService(this._allBuses);

  Set<String> _getAllStops(BusModel bus) {
    final stops = <String>{};
    if (_isBangla) {
      stops.add(bus.fromBn.toLowerCase());
      stops.add(bus.toBn.toLowerCase());
      stops.addAll(
        bus.stoppagesBn.map((s) => s.toLowerCase()),
      );
    } else {
      stops.add(bus.fromEn.toLowerCase());
      stops.add(bus.toEn.toLowerCase());
      stops.addAll(
        bus.stoppagesEn.map((s) => s.toLowerCase()),
      );
    }
    return stops;
  }

  RouteResult findRoute(
    String fromLocation,
    String toLocation,
  ) {
    _isBangla = _settingsController.isBangla.value;

    final from = fromLocation.toLowerCase().trim();
    final to = toLocation.toLowerCase().trim();

    if (from.isEmpty || to.isEmpty) {
      return NoRouteFound();
    }

    for (final bus in _allBuses) {
      final busStops = _getAllStops(bus);

      bool hasFrom = busStops.any(
        (stop) =>
            stop.isNotEmpty && from.contains(stop) ||
            stop.contains(from),
      );
      bool hasTo = busStops.any(
        (stop) =>
            stop.isNotEmpty &&
            (to.contains(stop) || stop.contains(to)),
      );

      if (hasFrom && hasTo) {
        return DirectRoute(bus);
      }
    }

    final groupA = <BusModel>[];
    final groupB = <BusModel>[];

    for (final bus in _allBuses) {
      final busStops = _getAllStops(bus);
      bool hasFrom = busStops.any(
        (stop) =>
            stop.isNotEmpty &&
            (from.contains(stop) || stop.contains(from)),
      );
      bool hasTo = busStops.any(
        (stop) =>
            stop.isNotEmpty &&
            (to.contains(stop) || stop.contains(to)),
      );

      if (hasFrom) groupA.add(bus);
      if (hasTo) groupB.add(bus);
    }

    for (final busA in groupA) {
      final stopsA = _getAllStops(busA);
      for (final busB in groupB) {
        if (busA.nameEn == busB.nameEn) continue;

        final stopsB = _getAllStops(busB);
        final commonStops = stopsA.intersection(stopsB);

        commonStops.removeWhere(
          (stop) =>
              stop.isEmpty ||
              from.contains(stop) ||
              stop.contains(from),
        );
        commonStops.removeWhere(
          (stop) =>
              stop.isEmpty ||
              to.contains(stop) ||
              stop.contains(to),
        );

        if (commonStops.isNotEmpty) {
          return TransferRoute(
            busA,
            busB,
            StringExtension(commonStops.first).capitalize(),
          );
        }
      }
    }

    return NoRouteFound();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return "";
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
