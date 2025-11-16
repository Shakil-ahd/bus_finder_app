class BusModel {
  final String nameEn;
  final String nameBn;
  final String fromEn;
  final String fromBn;
  final String toEn;
  final String toBn;
  final double farePerKm;
  final int minFare;
  final List<String> stoppagesEn;
  final List<String> stoppagesBn;

  BusModel({
    required this.nameEn,
    required this.nameBn,
    required this.fromEn,
    required this.fromBn,
    required this.toEn,
    required this.toBn,
    required this.farePerKm,
    required this.minFare,
    required this.stoppagesEn,
    required this.stoppagesBn,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      nameEn: json['nameEn'] ?? '',
      nameBn: json['nameBn'] ?? '',
      fromEn: json['fromEn'] ?? '',
      fromBn: json['fromBn'] ?? '',
      toEn: json['toEn'] ?? '',
      toBn: json['toBn'] ?? '',
      farePerKm:
          (json['farePerKm'] as num?)?.toDouble() ?? 2.42,
      minFare: (json['minFare'] as num?)?.toInt() ?? 10,
      stoppagesEn: (json['stoppagesEn'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      stoppagesBn: (json['stoppagesBn'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameEn': nameEn,
      'nameBn': nameBn,
      'fromEn': fromEn,
      'fromBn': fromBn,
      'toEn': toEn,
      'toBn': toBn,
      'farePerKm': farePerKm,
      'minFare': minFare,
      'stoppagesEn': stoppagesEn,
      'stoppagesBn': stoppagesBn,
    };
  }
}
