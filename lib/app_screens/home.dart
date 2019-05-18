import 'package:flutter/material.dart';
import './split_bill_screen.dart';

class BillSplitterState extends State<BillSplitter> {
  double subTotalAmount = 0.0;
  double serviceChargeAmount = 0.0;
  double taxAmount = 0.0;
  double totalAmount = 0.0;
  String billName = "Untitled";
  int personCount = 1;

  @override
  Widget build(BuildContext context) {
    double computeServiceCharge() {
      return subTotalAmount * (serviceChargeAmount / 100);
    }

    double computeTax() {
      return (subTotalAmount + computeServiceCharge()) * (taxAmount / 100);
    }

    void updateTotalAmount(){
      totalAmount = subTotalAmount + computeServiceCharge() + computeTax();
    }

    TextField billNameField = new TextField(
        decoration: new InputDecoration(labelText: "Name", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          setState(() {
            billName = value.trim().length == 0 ? "Untitled" : value;
          });
        },
    );
    
    TextField billAmountField = new TextField(
        decoration: new InputDecoration(labelText: "Subtotal", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          setState(() {
            try {
              subTotalAmount = double.parse(value);
            } catch (exception) {
              subTotalAmount = 0.0;
            }
            updateTotalAmount();
          });
        },
    );

    TextField serviceChargeField = new TextField(
        decoration: new InputDecoration(labelText: "Service Charge (%)", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          setState(() {
            try {
              serviceChargeAmount = double.parse(value);
            } catch (exception) {
              serviceChargeAmount = 0.0;
            }
            updateTotalAmount();
          });
        });

    TextField taxAmountField = new TextField(
        decoration: new InputDecoration(labelText: "Tax Rate (%)", labelStyle: TextStyle(fontSize: 20)),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        onChanged: (String value) {
          setState(() {
            try {
              taxAmount = double.parse(value);
            } catch (exception) {
              taxAmount = 0.0;
            }
            updateTotalAmount();
          });
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
          String formattedTotal = totalAmount.toStringAsFixed(2);

          AlertDialog dialog = new AlertDialog(
              content: new Text("Total is $formattedTotal per person"));

          showDialog(context: context, builder: (BuildContext context) => dialog);
        });

    void _startSplitByPerson() {
      var splitData = {
        "subTotalAmount": subTotalAmount,
        "serviceChargeAmount": serviceChargeAmount,
        "taxAmount": taxAmount,
        "personCount": personCount,
        "serviceChargeValue": computeServiceCharge(),
        "taxValue": computeTax(),
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

    Container summarySubtotal = Container(
      child: Column(
        children: <Widget>[
          Text("Name: $billName", style: TextStyle(fontSize: 18),),
          Padding(padding: EdgeInsets.only(top: 3.0),),
          Text("Subtotal: " + subTotalAmount.toStringAsFixed(2), style: TextStyle(fontSize: 18),),
          Padding(padding: EdgeInsets.only(top: 3.0),),
          Text("Service Charge: " + computeServiceCharge().toStringAsFixed(2), style: TextStyle(fontSize: 18),),
          Padding(padding: EdgeInsets.only(top: 3.0),),
          Text("Tax: " + computeTax().toStringAsFixed(2), style: TextStyle(fontSize: 18),),
          Padding(padding: EdgeInsets.only(top: 3.0),),
          Text("Total: " + totalAmount.toStringAsFixed(2), style: TextStyle(fontSize: 18),),
        ],),
    );

    Container container = new Container(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
            children: [
              billNameField,
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
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              summarySubtotal
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