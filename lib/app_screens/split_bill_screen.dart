import 'package:flutter/material.dart';

class SplitBillScreen extends StatelessWidget {
  final Map data;

  SplitBillScreen({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double subTotalAmount = data["subTotalAmount"];
    final double serviceChargeAmount = data["serviceChargeAmount"];
    final double taxAmount = data["taxAmount"];
    final int personCount = data["personCount"];

    String formattedSubTotalAmount = subTotalAmount.toStringAsFixed(2);

    Text subTotalText = Text(
      "Subtotal is $formattedSubTotalAmount",
      style: TextStyle(fontSize: 20)
    );

    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            children: [
              subTotalText
            ]));

    AppBar appBar = new AppBar(title: new Text("Split by person"), backgroundColor: Colors.red,);

    Scaffold scaffold = new Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}