import 'package:flutter/material.dart';

class SplitItem {
  final String name;
  final double cost;

  SplitItem(this.name, this.cost);
}

class SplitBillScreenState extends State<SplitBillScreen> {
  @override
  Widget build(BuildContext context) {
    final List<SplitItem> splitItems = <SplitItem>[];
    double subTotalAmount = widget.splitData["subTotalAmount"];
    final double serviceChargeAmount = widget.splitData["serviceChargeAmount"];
    final double taxAmount = widget.splitData["taxAmount"];
    final int personCount = widget.splitData["personCount"];

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

class SplitBillScreen extends StatefulWidget {
  final Map splitData;

  SplitBillScreen({Key key, @required this.splitData}) : super(key: key);

  @override
  SplitBillScreenState createState() => SplitBillScreenState();
}
