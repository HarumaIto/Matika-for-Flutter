import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';

import '../data/coordinate.dart';

class GeoSearchRepository {
  static const collectionName = 'sample_locations';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Coordinateを中心としたradiusの範囲のDocumentをList形式で取得
  // radius [kilometers]
  Future<List<Coordinate>> read(Coordinate coordinate, double radius) async {
    // 必要なインスタンスを初期化
    GeoFirestore geoFirestore = GeoFirestore(_db.collection(collectionName));
    final queryLocation = GeoPoint(coordinate.latitude, coordinate.longitude);

    return _convertFieldToCoordinate(
        await geoFirestore.getAtLocation(queryLocation, radius)
    );
  }

  // documentのfield値からCoordinateクラスへ変換する
  List<Coordinate> _convertFieldToCoordinate(List<DocumentSnapshot> docs) {
    List<Coordinate> coordinates = [];
    for (var doc in docs) {
      if (doc.exists) {
        GeoPoint geoPoint = doc.get('l');
        coordinates.add(Coordinate(
            latitude: geoPoint.latitude,
            longitude: geoPoint.longitude,
            altitude: doc.get('altitude')
        ));
      }
    }
    return coordinates;
  }
}