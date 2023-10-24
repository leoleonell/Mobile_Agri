import 'package:flutter/material.dart';
import 'myhomepage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gyms App',
        debugShowCheckedModeBanner: false,
        home:MyHomePage()
    );
  }

}

