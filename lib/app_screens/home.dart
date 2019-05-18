import 'package:flutter/material.dart';
import './split_bill_screen.dart';

class BillSplitterState extends State<BillSplitter> {
  String billName = "Untitled";
  double subTotalAmount = 0.0;
  double serviceChargeAmount = 0.0;
  double taxAmount = 0.0;
  double totalAmount = 0.0;
  int personCount = 1;

  final TextEditingController _billNameTextFieldController = new TextEditingController();
  final TextEditingController _subTotalTextFieldController = new TextEditingController();
  final TextEditingController _serviceChargeTextFieldController = new TextEditingController();
  final TextEditingController _taxTextFieldController = new TextEditingController();
  final TextEditingController _personTextFieldController = new TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _billNameTextFieldController.dispose();
    _subTotalTextFieldController.dispose();
    _serviceChargeTextFieldController.dispose();
    _taxTextFieldController.dispose();
    _personTextFieldController.dispose();
    super.dispose();
  }

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

    void clearFields() {
      setState(() {
        subTotalAmount = 0.0;
        billName = "Untitled";
        serviceChargeAmount = 0.0;
        taxAmount = 0.0;
        personCount = 0;
        totalAmount = 0;

        _billNameTextFieldController.clear();
        _subTotalTextFieldController.clear();
        _serviceChargeTextFieldController.clear();
        _taxTextFieldController.clear();
        _personTextFieldController.clear(); 
      });
    }

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

    TextField billNameField = new TextField(
      controller: _billNameTextFieldController,
      decoration: new InputDecoration(labelText: "Name", labelStyle: TextStyle(fontSize: 20)),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (String value) {
        setState(() {
          billName = value.trim().length == 0 ? "Untitled" : value.trim();
        });
      },
    );
    
    TextField billAmountField = new TextField(
      controller: _subTotalTextFieldController,
      decoration: new InputDecoration(labelText: "Subtotal", labelStyle: TextStyle(fontSize: 20)),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      onChanged: (String value) {
        setState(() {
          try {
            subTotalAmount = double.parse(value.trim());
          } catch (exception) {
            subTotalAmount = 0.0;
          }
          updateTotalAmount();
        });
      },
    );

    TextField serviceChargeField = new TextField(
      controller: _serviceChargeTextFieldController,
      decoration: new InputDecoration(labelText: "Service Charge / Tip (%)", labelStyle: TextStyle(fontSize: 20)),
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
      controller: _taxTextFieldController,
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
      controller: _personTextFieldController,
      decoration: new InputDecoration(labelText: "No. of people", labelStyle: TextStyle(fontSize: 20)),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      onChanged: (String value) {
        try {
          personCount = int.parse(value);
        } catch (exception) {
          personCount = 1;
        }
        updateTotalAmount();
      });

    MaterialButton calculateEquallyButton = new MaterialButton(
      child: new Text("Split Equally"),
      color: Colors.red,
      textColor: Colors.white,
      onPressed: () {
        String formattedTotal = "0";

        if (personCount != 0) {
          formattedTotal = (totalAmount / personCount).toStringAsFixed(2);
        }

        AlertDialog dialog = new AlertDialog(
            content: new Text("Total is $formattedTotal per person"));

        showDialog(context: context, builder: (BuildContext context) => dialog);
      });


    MaterialButton splitByPersonButton = new MaterialButton(
      child: new Text("Split By Person"),
      color: Colors.red,
      textColor: Colors.white,
      onPressed: _startSplitByPerson);

    MaterialButton clearButton = new MaterialButton(
      child: new Text("clear"),
      color: Colors.grey,
      textColor: Colors.black,
      onPressed: clearFields);

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
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                ), 
                clearButton,
                new Expanded(child: Container(),),
              ],),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            summarySubtotal
          ]));

    AppBar appBar = new AppBar(
      title: Row(
        children: <Widget>[
          Icon(Icons.attach_money),
          Text("BillSplitter"),
        ],
      ),
      backgroundColor: Colors.red,);

    Scaffold scaffold = new Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

class BillSplitter extends StatefulWidget {
  @override
  BillSplitterState createState() => BillSplitterState();
}