import 'package:flutter/material.dart';
import './split_bill_screen.dart';

class BillSplitterState extends State<BillSplitter> {
  double subTotalAmount = 0.0;
  double serviceChargeAmount = 0.0;
  double taxAmount = 0.0;
  int personCount = 1;

  @override
  Widget build(BuildContext context) {
    TextField billAmountField = new TextField(
        decoration: new InputDecoration(labelText: "Subtotal", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          try {
            subTotalAmount = double.parse(value);
          } catch (exception) {
            subTotalAmount = 0.0;
          }
        },
    );

    TextField serviceChargeField = new TextField(
        decoration: new InputDecoration(labelText: "Service Charge", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          try {
            serviceChargeAmount = double.parse(value);
          } catch (exception) {
            serviceChargeAmount = 0.0;
          }
        });

    TextField taxAmountField = new TextField(
        decoration: new InputDecoration(labelText: "Tax Amount", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          try {
            taxAmount = double.parse(value);
          } catch (exception) {
            taxAmount = 0.0;
          }
        });

    TextField personCountField = new TextField(
        decoration: new InputDecoration(labelText: "No. of people", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          try {
            personCount = int.parse(value);
          } catch (exception) {
            personCount = 1;
          }
        });

    MaterialButton calculateEquallyButton = new MaterialButton(
        child: new Text("Split Equally"),
        color: Colors.red,
        textColor: Colors.white,
        onPressed: () {
          double total = subTotalAmount + serviceChargeAmount + taxAmount;
          total = total / personCount;

          String formattedTotal = total.toStringAsFixed(2);

          AlertDialog dialog = new AlertDialog(
              content: new Text("Total is $formattedTotal per person"));

          showDialog(context: context, builder: (BuildContext context) => dialog);
        });

    void _startSplitByPerson() {
      var splitData = {
        "subTotalAmount": subTotalAmount,
        "serviceChargeAmount": serviceChargeAmount,
        "taxAmount": taxAmount,
        "personCount": personCount
      };
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => SplitBillScreen(splitData: splitData),
        ),
      );
    }

    MaterialButton splitByPersonButton = new MaterialButton(
        child: new Text("Split By Person"),
        color: Colors.red,
        textColor: Colors.white,
        onPressed: _startSplitByPerson);


    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              billAmountField,
              serviceChargeField,
              taxAmountField,
              personCountField,
              Container(
                alignment: Alignment(0.0, 0.0),
                child: Row(children: <Widget>[
                  new Expanded(child: Container(),),
                  calculateEquallyButton,
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ), 
                  splitByPersonButton,
                  new Expanded(child: Container(),),
                ],),
              ),
            ]));

    AppBar appBar = new AppBar(title: new Text("BillSplitter"), backgroundColor: Colors.red,);

    Scaffold scaffold = new Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

class BillSplitter extends StatefulWidget {
  @override
  BillSplitterState createState() => BillSplitterState();
}