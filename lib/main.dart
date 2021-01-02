import 'package:flutter/material.dart';
import './homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Multiple screens',
    initialRoute: '/homepage',
    routes: {
      '/homepage': (context) => HomePage(), // Μονοπατι για HomePage
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}