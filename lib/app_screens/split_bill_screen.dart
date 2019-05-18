import 'package:flutter/material.dart';

class SplitItem {
  final String name;
  final double cost;
  final int index;

  SplitItem(this.name, this.cost, this.index);
}

class SplitBillScreenState extends State<SplitBillScreen> {
  Set<String> whoSharedItem = new Set<String>();
  double remainingAmount;

  @override
  Widget build(BuildContext context) {
    final Set<SplitItem> splitItems = Set<SplitItem>();
    double subTotalAmount = widget.splitData["subTotalAmount"];
    final double serviceChargeAmount = widget.splitData["serviceChargeAmount"];
    final double taxAmount = widget.splitData["taxAmount"];
    final int personCount = widget.splitData["personCount"];
    remainingAmount = subTotalAmount;

    String formattedSubTotalAmount = subTotalAmount.toStringAsFixed(2);

    for(var i=0; i < personCount; i++) {
      String name = "Person " + (i+1).toString();
      splitItems.add(SplitItem(name, 0, i),);
    }

    Text subTotalText = Text(
      "Subtotal is $formattedSubTotalAmount",
      style: TextStyle(fontSize: 20)
    );

    TextField itemField = new TextField(
      decoration: new InputDecoration(
        labelText: "Receipt Item", 
        labelStyle: TextStyle(fontSize: 20),
        suffix: IconButton(
          icon: Icon(Icons.add), 
          onPressed: () {
            SimpleDialog dialog = SimpleDialog(
              title: Text("Who shared this item?"),
              children: splitItems.map((element) {
                return new CheckboxListTile(
                  title: Text(element.name),
                  value: whoSharedItem.contains(element.name),
                  onChanged: (bool value) {
                    setState(() {
                      if(value) {
                        whoSharedItem.add(element.name);
                      }
                      else {
                        whoSharedItem.remove(element.name);
                      }
                      print(whoSharedItem);
                    });
                  },
                );
              }).toList(),
            );
            showDialog(context: context, builder: (BuildContext context) => dialog);
          },
        )
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      onChanged: (String value) {
      },
    );

    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            children: [
              subTotalText,
              Padding(padding: EdgeInsets.only(top: 15),),
              itemField,
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
