import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:matika/gps_utli.dart';
import 'package:vector_math/vector_math_64.dart';

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

  // ノードオブジェクトのモデルクラス
  ARNode? localObjectNode;

  // オブジェクトを配置する座標
  double latitude = 35.102902;
  double longitude = 136.722996;
  double altitude = 1;

  @override
  void initState() {
    super.initState();
    GPSUtil.checkLocationPermission();
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateObjectPosition();

    return Scaffold(
      appBar: AppBar(
        title: const Text("AR Map View"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ARView(
          onARViewCreated: onARViewCreated,
        ),
      ),
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
  Future<void> updateObjectPosition() async {
    Vector3 targetPosition = await GPSUtil.convertCoordinate(latitude, longitude, altitude);
    print(targetPosition);

    if (localObjectNode != null) {
      // すでにオブジェクトを作成していたら
      setState(() {
        localObjectNode!.position = targetPosition;
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
        localObjectNode = (didAddLocalNode!) ? newNode : null;
      });
    }
  }
}