import 'dart:io';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:matika/business_logic/active_object_logic.dart';
import 'package:matika/data/coordinate.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../business_logic/gps_logic.dart';

class ARMapPage extends StatefulWidget {
  const ARMapPage({Key? key}) : super(key: key);

  @override
  State<ARMapPage> createState() => _ARMapPageState();
}

class _ARMapPageState extends State<ARMapPage> {
  // ARKitViewに関連するイベントを管理します
  ARKitController? arKitController;

  // 配置するオブジェクトの座標
  ActiveObjectLogic activeObjectLogic = ActiveObjectLogic();
  List<Map<String, dynamic>> coordinates = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (arKitController != null) arKitController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const Center(
        child: Text('Androidは近日実装予定です'),
      );
    }

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
            onARKitViewCreated: onARKitViewCreated,
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
    setObjectsNodes();
  }

  // 決められた範囲のオブジェクトを設置する
  void setObjectsNodes() async {
    // 一つもデータがなければ処理の軽減のためにreturnする
    if (coordinates.isEmpty) return;

    // Test用Nodeを作成する
    // 必要なければコメントアウトする
    createTestNode();

    // 現在位置を取得
    Coordinate currentCoordinate = await GpsLogic.getCurrentCoordinate();
    // 親要素との差分で配置する
    for (int i=0; i<coordinates.length; i++) {
      // 表示する位置を取得
      vector.Vector3 displayPosition
          = await GpsLogic.convertCoordinate(coordinates[i]['coordinate'], currentCoordinate);
      // 新しいオブジェクトを生成
      var node = ARKitReferenceNode(
        url: 'yazirushi.dae',
        position: displayPosition,
        scale: vector.Vector3.all(1),
      );
      // ARKitControllerに追加
      arKitController!.add(node);
      // オブジェクトの上にテキストを表示させる
      drawText(coordinates[i]['name'], displayPosition);
    }
  }

  // AR空間にテキストを表示させる
  void drawText(String text, vector.Vector3 nodePosition) {
    // オブジェクトの上にテキストを表示させたいため
    final position = vector.Vector3(
      nodePosition.x,
      nodePosition.y + 0.1,
      nodePosition.z
    );
    final textGeometry = ARKitText(
      text: text,
      extrusionDepth: 0.2,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.white)
        )
      ]
    );
    const scale = 0.1;
    final vectorScale = vector.Vector3(scale, scale, scale);
    final node = ARKitNode(
      geometry: textGeometry,
      position: position,
      scale: vectorScale,
    );
    arKitController!.add(node);
  }

  // デバッグ用にNodeを作成する
  void createTestNode() {
    var testNode = ARKitReferenceNode(
        url: 'yazirushi.dae',
        position: vector.Vector3(0,0,-10),
        scale: vector.Vector3.all(1)
    );
    arKitController!.add(testNode);
    drawText('test', vector.Vector3(0,0,-10));
  }
}