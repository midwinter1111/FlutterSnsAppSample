import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:udemy_snsapp/view/screen.dart';
import 'package:udemy_snsapp/view/start_up/login_page.dart';
import 'package:udemy_snsapp/view/time_line/time_line_page.dart';

import 'config/configurations.dart';

final configurations = Configurations();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'flutter-sns',
    options: FirebaseOptions(
        apiKey: configurations.apiKey,
        appId: configurations.appId,
        messagingSenderId: configurations.messagingSenderId,
        storageBucket: configurations.storageBucket,
        projectId: configurations.projectId)
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
