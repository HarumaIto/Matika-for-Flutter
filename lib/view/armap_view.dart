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
    for (int i=0; i<coordinates.length; i++) {
      Vector3 targetPosition = await GpsLogic.convertCoordinate(coordinates[i]['coordinate']);

      // 新しいオブジェクトを生成
      var node = ARKitNode(
        name: coordinates[i]['name'],
        geometry: ARKitSphere(radius: 0.5),
        position: targetPosition,
      );

      // ARKitSceneViewにセットする
      arKitController.add(node);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}