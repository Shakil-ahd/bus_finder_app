// lib/services/route_finder_service.dart
import '../models/bus_model.dart';
import '../data/bus_data.dart';

// --- এই ক্লাসগুলো সার্চের রেজাল্ট কেমন হবে তা ঠিক করে ---

// এটি মূল ক্লাস
abstract class RouteResult {}

// ১. সরাসরি বাস পেলে এই ক্লাসটি ব্যবহৃত হবে
class DirectRoute extends RouteResult {
  final BusModel bus;
  DirectRoute(this.bus);
}

// ২. ট্রান্সফার রুট পেলে এই ক্লাসটি ব্যবহৃত হবে
class TransferRoute extends RouteResult {
  final BusModel busA; // প্রথম বাস
  final BusModel busB; // দ্বিতীয় বাস
  final String junctionStop; // যেখানে বাস বদলাতে হবে
  TransferRoute(this.busA, this.busB, this.junctionStop);
}

// ৩. কোনো রুট না পেলে এটি ব্যবহৃত হবে
class NoRouteFound extends RouteResult {}

// --- মূল সার্ভিস ক্লাস (The Brain) ---
class RouteFinderService {
  final List<BusModel> _allBuses = busList;
  bool _isBangla = false;

  // একটি বাসের সব স্টপেজ (from, to, stoppages) খুঁজে বের করার ফাংশন
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

  // --- ❗️ মূল রুট খোঁজার অ্যালগরিদম ---
  RouteResult findRoute(
    String fromLocation,
    String toLocation,
    bool isBangla,
  ) {
    _isBangla = isBangla;
    final from = fromLocation.toLowerCase();
    final to = toLocation.toLowerCase();

    // --- ধাপ ১: সরাসরি রুট (Direct Route) খোঁজা ---
    for (final bus in _allBuses) {
      final busStops = _getAllStops(bus);

      // চেক করুন: এই বাসের রুটে 'from' এবং 'to' দুটি জায়গাই আছে কি না
      // আমরা 'contains' ব্যবহার করছি কারণ ম্যাপের ঠিকানা ("Mirpur 10, Dhaka")
      // আর বাসের ডেটা ("Mirpur 10") হুবহু এক নাও হতে পারে।
      bool hasFrom = busStops.any(
        (stop) =>
            from.contains(stop) || stop.contains(from),
      );
      bool hasTo = busStops.any(
        (stop) => to.contains(stop) || stop.contains(to),
      );

      if (hasFrom && hasTo) {
        return DirectRoute(bus); // সরাসরি রুট পাওয়া গেছে!
      }
    }

    // --- ধাপ ২: এক-ট্রান্সফার রুট (1-Transfer Route) খোঁজা ---
    final groupA =
        <BusModel>[]; // 'From' লোকেশন দিয়ে যায় এমন সব বাস
    final groupB =
        <BusModel>[]; // 'To' লোকেশন দিয়ে যায় এমন সব বাস

    for (final bus in _allBuses) {
      final busStops = _getAllStops(bus);
      bool hasFrom = busStops.any(
        (stop) =>
            from.contains(stop) || stop.contains(from),
      );
      bool hasTo = busStops.any(
        (stop) => to.contains(stop) || stop.contains(to),
      );

      if (hasFrom) groupA.add(bus);
      if (hasTo) groupB.add(bus);
    }

    // এখন groupA এবং groupB-এর মধ্যে একটি কমন স্টপেজ (Junction) খুঁজুন
    for (final busA in groupA) {
      final stopsA = _getAllStops(busA);
      for (final busB in groupB) {
        if (busA.nameEn == busB.nameEn)
          continue; // একই বাস চেক করার দরকার নেই

        final stopsB = _getAllStops(busB);

        // দুটি বাসের কমন স্টপেজগুলো খুঁজুন
        final commonStops = stopsA.intersection(stopsB);

        // শুরু বা শেষ লোকেশনকে জংশন হিসেবে ধরা যাবে না
        commonStops.removeWhere(
          (stop) =>
              from.contains(stop) || stop.contains(from),
        );
        commonStops.removeWhere(
          (stop) => to.contains(stop) || stop.contains(to),
        );

        if (commonStops.isNotEmpty) {
          // ট্রান্সফার রুট পাওয়া গেছে!
          return TransferRoute(
            busA,
            busB,
            commonStops.first.capitalize(),
          );
        }
      }
    }

    // --- ধাপ ৩: কোনো রুট পাওয়া যায়নি ---
    return NoRouteFound();
  }
}

// একটি ছোট হেল্পার (string-এর প্রথম অক্ষর বড় হাতের করার জন্য)
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return "";
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
