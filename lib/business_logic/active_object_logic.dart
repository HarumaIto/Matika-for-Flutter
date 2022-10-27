import 'package:matika/business_logic/gps_logic.dart';
import 'package:matika/repository/geo_search_repository.dart';

import '../data/coordinate.dart';

class ActiveObjectLogic {
  // Mapに表示するオブジェクトを返す
  Future<List<Coordinate>> getObjects() async {
    // 現在位置を取得
    Coordinate currentCoordinate = await GpsLogic.getCurrentCoordinate();
    // 設定のデータから個数と範囲を取得

    // 2次元座標と位置情報から検索する
    GeoSearchRepository geoSearchRepository = GeoSearchRepository();
    // geoFirestoreに個数のプロパティを設定する
    return await geoSearchRepository.read(currentCoordinate, 0.3);
  }
}