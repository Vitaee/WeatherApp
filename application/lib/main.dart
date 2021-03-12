import 'package:flutter/material.dart';
import 'widgets/my_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData.dark(),
      home: MyHomePage(
        title: 'Weather App',
        text: "Weather City",
      ),
    );
  }
}
