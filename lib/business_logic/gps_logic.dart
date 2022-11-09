import 'dart:math' show asin, atan2, cos, pow, sin, sqrt;

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
  // 参考 https://github.com/rakuishi/guidepost/blob/master/app/src/main/java/com/rakuishi/guidepost/ArUtils.kt
  static Future<Vector3> convertCoordinate(
      Coordinate targetCoordinate, Coordinate currentCoordinate) async {
    // ２点間の距離を取得する
    double distance = calculateDistance(currentCoordinate, targetCoordinate);
    // ２点間の角度を取得する
    double bearing = _calculateBearing(currentCoordinate, targetCoordinate);
    // ２点間の高度差を取得する
    double height = _calculateHeight(currentCoordinate.altitude, targetCoordinate.altitude);

    // 方位から回転角に変換
    double orientation = await _calculateOrientation();
    double rotation = bearing - orientation;
    double radRotation = radians(rotation);

    return Vector3(
        distance * sin(radRotation),
        height,
        -distance * cos(radRotation)
    );
  }

  // 2点間距離を計算する
  static double calculateDistance(Coordinate current, Coordinate target) {
    double radCurrentLat = radians(current.latitude);
    double radCurrentLon = radians(current.longitude);
    double radTargetLat = radians(target.latitude);
    double radTargetLon = radians(target.longitude);

    // equatorial radius
    double r = 6378137.0;
    double averageLat = (radCurrentLat - radTargetLat) / 2;
    double averageLon = (radCurrentLon - radTargetLon) / 2;
    return 2 * r * asin(sqrt(pow(sin(averageLat), 2) + cos(radCurrentLat) * cos(radTargetLat) * pow(sin(averageLon), 2)));
  }

  static double _calculateBearing(Coordinate current, Coordinate target) {
    double radCurrentLat = radians(current.latitude);
    double radTargetLat = radians(target.latitude);
    double diffLon = radians(target.longitude - current.longitude);

    double x = cos(radCurrentLat) * sin(radTargetLat) - sin(radCurrentLat) * cos(radTargetLat) * cos(diffLon);
    double y = cos(radTargetLat) * sin(diffLon);
    return degrees(atan2(y, x) + 360) % 360;
  }

  // 方位を計算する
  static Future<double> _calculateOrientation() async {
    CompassEvent event = await FlutterCompass.events!.first;
    return degrees(event.heading! + 360) % 360;
  }

  // 2点間の距離を計算します
  static double _calculateHeight(double num1, double num2) {
    return num2 - num1;
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
}