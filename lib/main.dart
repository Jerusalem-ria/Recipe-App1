import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
//import 'package:form/form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'recipie',
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}
