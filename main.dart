import 'package:flutter/material.dart';
import 'package:flutter_blog/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
