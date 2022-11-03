import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:matika/business_logic/active_object_logic.dart';
import 'package:matika/data/coordinate.dart';
import 'package:vector_math/vector_math_64.dart';

import '../business_logic/gps_logic.dart';

class ARMapView extends StatefulWidget {
  const ARMapView({Key? key}) : super(key: key);

  @override
  State<ARMapView> createState() => _ARMapViewState();
}

class _ARMapViewState extends State<ARMapView> {
  // ARKitViewに関連するイベントを管理します
  late ARKitController arKitController;

  // 配置するオブジェクトの座標
  ActiveObjectLogic activeObjectLogic = ActiveObjectLogic();
  List<Map<String, dynamic>> coordinates = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilderで現在地を取得する
    return FutureBuilder(
      future: activeObjectLogic.getObjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          coordinates.addAll(snapshot.data);
          return ARKitSceneView(
              onARKitViewCreated: onARKitViewCreated
          );
        } else {
          return const Center(child: Text('データがありません'),);
        }
      },
    );
  }

  // ARKitSceneViewから情報を経てそれぞれを初期化する
  void onARKitViewCreated(ARKitController arKitController) {
    this.arKitController = arKitController;
    setObjectsNode();
  }

  // 決められた範囲のオブジェクトを設置する
  void setObjectsNode() async {
    // 一つもデータがなければ処理の軽減のためにreturnする
    if (coordinates.isEmpty) return;

    // 現在位置を取得
    Coordinate currentCoordinate = await GpsLogic.getCurrentCoordinate();
    // 原点として親要素を空のジオメトリで配置する
    var originNode = ARKitNode(
      name: 'origin',
      geometry: ARKitSphere(radius: 0.01),
      position: Vector3(0, 0, 0),
      eulerAngles: Vector3.zero()
    );
    arKitController.add(originNode);

    // 親要素との差分で配置する
    for (int i=0; i<coordinates.length; i++) {
      // 表示する位置を取得
      Vector3 displayPosition = await GpsLogic
          .convertCoordinate(coordinates[i]['coordinate'], currentCoordinate);

      // 新しいオブジェクトを生成
      var node = ARKitNode(
        geometry: ARKitSphere(radius: 0.8),
        position: displayPosition,
      );
      // 'origin'の子要素としてARKitControllerに追加
      arKitController.add(node, parentNodeName: 'origin');
    }
  }
}