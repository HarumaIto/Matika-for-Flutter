import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:matika/business_logic/gps_logic.dart';
import 'package:matika/data/size_config.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AddLocationPage extends StatefulWidget{
  @override
  AddLocationPageState createState() => AddLocationPageState();
}

class AddLocationPageState extends State<AddLocationPage> {
  late ARKitController arKitController;

  String locationName = '';

  @override
  void dispose() {
    arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('位置登録ページ'),
      ),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
      ),
    );
  }

  // Viewを初期化
  void onARKitViewCreated(ARKitController arKitController) {
    this.arKitController = arKitController;
  }

  void _showDialog() {
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('この位置を登録'),
        content: Column(
          children: [
            TextField(
              maxLines:1,
              decoration: const InputDecoration(
                icon: Icon(Icons.face),
                hintText: 'この位置を命名してください',
                labelText: '名前',
              ),
              onChanged: (value) => locationName = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: onAddLocation,
            child: const Text('OK'),
          ),
        ],
      );
    });
  }

  // 座標を追加
  void onAddLocation() async {
    // オブジェクトを追加
    var node = ARKitReferenceNode(
      url: 'yazirushi.dae',
      position: vector.Vector3.all(0),
      scale: vector.Vector3.all(1),
    );
    arKitController.add(node);

    // 位置情報などをデータベースへ登録
    GpsLogic.addLocationForFirestore(locationName);
  }
}