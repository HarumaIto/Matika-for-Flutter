import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matika/view/armap_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String infoText = '';

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onUserRegistration,
                  child: const Text('ユーザー登録'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onLogin,
                  child: const Text('ログイン'),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  // ユーザー登録
  void onUserRegistration() async {
    // メールパスワードでサインイン
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    // 画面遷移 + ログイン画面を廃棄
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const ARMapController();
      }),
    );
  }
  // ログイン
  void onLogin() async {
    // メールパスワードでログイン
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
        email: email,
        password: password
    );

    // 画面遷移 + ログイン画面を廃棄
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const ARMapController();
      })
    );
  }
}