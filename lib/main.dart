import 'package:flutter/material.dart';
import './homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Multiple screens',
    initialRoute:
        '/homepage', // Deixnei poia tha einai i selida pou tha deixnei me to pou ksekinaei to programma
    routes: {
      '/homepage': (context) => HomePage(), // Monopati gia to HomePage
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
