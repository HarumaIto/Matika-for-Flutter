import 'dart:math' show atan2, cos, pi, sin;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math_64.dart';

class GPSUtil {
  // ARで利用できる形に座標を変換する
  static Future<Vector3> convertCoordinate(
      double objectLatitude, double objectLongitude, double objectAltitude) async {
    // 現在位置を取得
    Position currentPosition = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double distance = Geolocator.distanceBetween(
        currentPosition.latitude, currentPosition.longitude,
        objectLatitude, objectLongitude);

    double angle = _angleFromCoordinate(
      currentPosition.latitude, currentPosition.longitude,
      objectLatitude, objectLongitude
    );

    int direction = await _calculateDegree(angle);
    if (direction == angle.truncate()) {
      // tan(90)
      return Vector3(0, objectAltitude, distance);
    } else if (direction == -angle.truncate()) {
      // tan(-90)
      return Vector3(0, objectAltitude, -distance);
    } else {
      double angleInRadian = _toRadian(angle - direction);
      return Vector3(
          sin(angleInRadian) * distance,
          objectAltitude,
          cos(angleInRadian) * distance
      );
    }
  }

  // 座標から２点角を計算する
  static double _angleFromCoordinate(
      double currentLat, double currentLong, double objectLat, double objectLong) {
    double phi1 = _toRadian(currentLat);
    double phi2 = _toRadian(objectLat);
    double lambda1 = _toRadian(currentLong);
    double lambda2 = _toRadian(objectLong);

    double y = sin(lambda2 - lambda1) * cos(phi2);
    double x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(lambda2- lambda1);
    double theta = atan2(y, x);
    double angle = (_toDegree(theta) + 360) % 360;

    return angle;
  }

  // 方位の差分を計算する
  static Future<int> _calculateDegree(double targetDegree) async {
    CompassEvent direction = await FlutterCompass.events!.first;
    return targetDegree.truncate() - direction.heading!.truncate();
  }

  // 位置情報の権限をリクエストする
  static void checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  static double _toRadian(double degree) {
    return degree * pi / 180;
  }

  static double _toDegree(double radian) {
    return radian * 180 / pi;
  }
}