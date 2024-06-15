import 'package:flutter/material.dart';

import 'AssetManagementScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AssetManagementScreen(),
    );
  }
}
