import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

void main() async{
  //to initialize packages before using
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tiktok",
      home: NavigationPage(),
    );
  }
}
