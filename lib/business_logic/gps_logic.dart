import 'dart:math' show atan2, cos, pi, sin;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matika/data/coordinate.dart';
import 'package:vector_math/vector_math_64.dart';

class GpsLogic {
  static Future<Coordinate> getCurrentCoordinate() async {
    Position currentPosition = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return Coordinate(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        altitude: currentPosition.altitude);
  }

  // 現在座標と目標座標から、モデルの表示位置を計算する
  static Future<Vector3> convertCoordinate(
      Coordinate targetCoordinate, Coordinate currentCoordinate) async {
    double distance = Geolocator.distanceBetween(
        currentCoordinate.latitude, currentCoordinate.longitude,
        targetCoordinate.latitude, targetCoordinate.longitude);
    double bearing = Geolocator.bearingBetween(
        currentCoordinate.latitude, currentCoordinate.longitude,
        targetCoordinate.latitude, targetCoordinate.longitude);
    double height = _calculateHeight(currentCoordinate.altitude, targetCoordinate.altitude);
    int direction = await _calculateDegree(bearing);

    if (direction == bearing.truncate()) {
      // tan(90)
      return Vector3(0, height, distance);
    } else if (direction == -bearing.truncate()) {
      // tan(-90)
      return Vector3(0, height, -distance);
    } else {
      double angleInRadian = _toRadian(bearing - direction);
      return Vector3(
          sin(angleInRadian) * distance,
          height,
          cos(angleInRadian) * distance
      );
    }
  }

  // 方位の差分を計算する
  static Future<int> _calculateDegree(double targetDegree) async {
    CompassEvent direction = await FlutterCompass.events!.first;
    return targetDegree.truncate() - direction.heading!.truncate();
  }

  // 位置情報の権限をリクエストする
  static Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error('Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    
    return true;
  }

  // 2点間の距離を計算します
  static double _calculateHeight(double num1, double num2) {
    return num2 - num1;
  }

  static double _toRadian(double degree) {
    return degree * pi / 180;
  }

  static double _toDegree(double radian) {
    return radian * 180 / pi;
  }
}