class LocationModel {
  final double lat;
  final double long;

//<editor-fold desc="Data Methods">

  const LocationModel({
    required this.lat,
    required this.long,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationModel && runtimeType == other.runtimeType && lat == other.lat && long == other.long);

  @override
  int get hashCode => lat.hashCode ^ long.hashCode;

  @override
  String toString() {
    return 'LocationModel{ lat: $lat, long: $long,}';
  }

  LocationModel copyWith({
    double? lat,
    double? long,
  }) {
    return LocationModel(
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      lat: map['lat'] as double,
      long: map['long'] as double,
    );
  }

//</editor-fold>
}
