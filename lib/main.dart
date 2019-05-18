import 'package:flutter/material.dart';
import './app_screens/home.dart';

void main() {
  runApp(BillSplitterMain());
}

class BillSplitterMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BillSplitter',
      home: BillSplitter(),
      theme: ThemeData( 
        primaryColor: Colors.red,
      ),
    );
  }
}
