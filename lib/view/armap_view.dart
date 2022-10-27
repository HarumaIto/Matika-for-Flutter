import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
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
  // ARViewに関連するイベントを管理します
  late ARSessionManager arSessionManager;
  // Nodeに関連するすべてのアクションを管理します
  late ARObjectManager arObjectManager;

  // 表示するオブジェクトを管理する
  List<ARNode?> objectNodes = [];

  // 配置するオブジェクトの座標
  ActiveObjectLogic activeObjectLogic = ActiveObjectLogic();
  List<Coordinate> coordinates = [];

  @override
  void initState() {
    super.initState();
    // パーミッションチェック
    GpsLogic.checkLocationPermission();
    // 表示するターゲットを取得
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateObjectsPosition();

    return SizedBox(
      child: FutureBuilder(
        future: activeObjectLogic.getObjects(),
        builder: (context, snapshot) {
          coordinates = snapshot.requireData;
          // 通信中はスピナーを表示
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          // エラー発生時はエラーメッセージを表示
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          // データがnullでないかチェック
          if (snapshot.hasData) {
            return ARView(
              onARViewCreated: onARViewCreated,
            );
          } else {
            return const Text("データが存在しません");
          }
        },
      )
    );
  }

  // ARViewから情報を経てそれぞれを初期化する
  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager
      ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    // セッションプロパティを設定して初期化
    this.arSessionManager.onInitialize();
    // 初期化
    this.arObjectManager.onInitialize();
  }

  // オブジェクトを設置する
  void updateObjectsPosition() async {
    // 決められた範囲のオブジェクトを表示させる
    for (int i=0; i<coordinates.length; i++) {
      Vector3 targetPosition = await GpsLogic.convertCoordinate(coordinates[i]);

      if (objectNodes[i] != null) {
        // すでにオブジェクトを作成していたら
        setState(() {
          objectNodes[i]!.position = targetPosition;
        });
      } else {
        // 新しいオブジェクトを生成
        var newNode = ARNode(
            type: NodeType.localGLTF2,
            uri: "assets/Chicken_01/Chicken_01.gltf",
            position: targetPosition,
            rotation: Vector4(1.0, 0.0, 0.0, 0.0)
        );
        // ARViewにセットする
        bool? didAddLocalNode = await arObjectManager.addNode(newNode);
        setState(() {
          objectNodes[i] = (didAddLocalNode!) ? newNode : null;
        });
      }
    }
  }
}