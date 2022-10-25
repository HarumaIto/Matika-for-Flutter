class Coordinate {
  double latitude;
  double longitude;
  double altitude;

//<editor-fold desc="Data Methods">

  Coordinate({
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coordinate &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          altitude == other.altitude);

  @override
  int get hashCode =>
      latitude.hashCode ^ longitude.hashCode ^ altitude.hashCode;

  @override
  String toString() {
    return 'Coordinate{ latitude: $latitude, longitude: $longitude, altitude: $altitude,}';
  }

  Coordinate copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
  }) {
    return Coordinate(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
    };
  }

  factory Coordinate.fromMap(Map<String, dynamic> map) {
    return Coordinate(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      altitude: map['altitude'] as double,
    );
  }

//</editor-fold>
}