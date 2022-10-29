import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../data/coordinate.dart';

class GeoSearchRepository {
  static const collectionName = 'sample_locations';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Coordinateを中心としたradiusの範囲のDocumentをList形式で取得
  // radius [kilometers]
  Future<List<DocumentSnapshot>> read(Coordinate coordinate, double radius) {
    // 必要なインスタンスを初期化
    final geo = GeoFlutterFire();
    // geoFirePointを生成
    GeoFirePoint center = geo.point(
        latitude: coordinate.latitude, longitude: coordinate.longitude);

    var collectionReference = _db.collection(collectionName);

    // リストで帰ってくるので初めにゲットできるものがすべて
    return geo.collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: 'position').first;
  }
  
  void write() {
    // 必要なインスタンスを初期化
    final geo = GeoFlutterFire();
    GeoFirePoint location = geo.point(latitude: 35.1022847, longitude: 136.7240748);

    // Firestoreへデータ追加
    _db.collection(collectionName)
        . add({'name': '近所の公衆トイレ', 'position': location.data, 'altitude': 1});
  }
}