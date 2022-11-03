import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matika/business_logic/gps_logic.dart';
import 'package:matika/repository/geo_search_repository.dart';

import '../data/coordinate.dart';

class ActiveObjectLogic {

  // Mapに表示するオブジェクトを返す
  Future getObjects() async {
    // 現在位置を取得
    Coordinate currentCoordinate = await GpsLogic.getCurrentCoordinate();
    // 設定のデータから個数と範囲を取得

    // 2次元座標と位置情報から検索する
    GeoSearchRepository geoSearchRepository = GeoSearchRepository();
    // geoFirestoreに個数のプロパティを設定する
    return _convertFieldToCoordinate(
        await geoSearchRepository.read(currentCoordinate, 1)
    );
  }

  // documentのfield値からCoordinateクラスへ変換する
  List<Map> _convertFieldToCoordinate(List<DocumentSnapshot> docs) {
    List<Map<String, dynamic>> locationData = [];
    for (var doc in docs) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        GeoPoint geoPoint = data['position']['geopoint'];
        locationData.add({
          'name': data['name'],
          'coordinate': Coordinate(
              latitude: geoPoint.latitude,
              longitude: geoPoint.longitude,
              altitude: data['altitude'].toDouble()
          )
        });
      }
    }
    print('Coordinate List => ${locationData.length}');
    return locationData;
  }
}