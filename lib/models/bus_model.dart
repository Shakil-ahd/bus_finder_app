// lib/models/bus_model.dart
class BusModel {
  final String nameEn;
  final String nameBn;
  final String fromEn;
  final String fromBn;
  final String toEn;
  final String toBn;
  final int fare;
  final List<String> stoppagesEn;
  final List<String> stoppagesBn;

  BusModel({
    required this.nameEn,
    required this.nameBn,
    required this.fromEn,
    required this.fromBn,
    required this.toEn,
    required this.toBn,
    required this.fare,
    required this.stoppagesEn,
    required this.stoppagesBn,
  });
}
