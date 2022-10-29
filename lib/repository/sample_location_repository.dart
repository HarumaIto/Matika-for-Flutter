import 'package:cloud_firestore/cloud_firestore.dart';

class SampleLocationRepository {
  static const collectionName = 'sample_locations';

  final _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> readLocation() async {
    // すべてのサンプルのデータを取得する
    return await _db.collection(collectionName).get();
  }
}