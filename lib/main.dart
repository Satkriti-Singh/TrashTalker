import 'package:flutter/material.dart';
import 'package:trash_talker/ShowDataPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light
      ),
      home: ShowDataPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


