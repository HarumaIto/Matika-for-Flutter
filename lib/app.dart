import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'business_logic/gps_logic.dart';
import 'view/armap_controller.dart';
import 'view/login_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matika',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // スプラッシュ画面に書き換える
            return const SizedBox();
          }
          if (snapshot.hasData) {
            // パーミッションチェック
            return FutureBuilder(
                future: GpsLogic.checkLocationPermission(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // サインイン済み && 権限の許可済み
                    return const ARMapController();
                  }
                  return const SizedBox();
                }
            );
          }
          // 未サインイン状態
          return const LoginView();
        },
      ),
    );
  }
}