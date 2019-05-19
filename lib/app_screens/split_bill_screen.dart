import 'package:flutter/material.dart';
import '../widgets/person_shared_dialog.dart';

class SplitItem {
  final String name;
  final double cost;
  final int index;

  SplitItem(this.name, this.cost, this.index);
}

class SplitBillScreenState extends State<SplitBillScreen> {
  Set<String> whoSharedItem = new Set<String>();
  double itemAmount = 0.0;
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
          color: Colors.red,
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context) {
              final List<String> peopleSharing = splitItems.map((element) { return element.name; }).toList();
              return PersonSharedDialog(
                peopleSharing: peopleSharing,
                selectedPeopleSharing: whoSharedItem,
                onSelectedPeopleSharing: (selectedPeople) {
                  whoSharedItem = selectedPeople;
                  print(whoSharedItem);
                },
              );
            });
          },
        )
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      onChanged: (String value) {
        setState(() {
         try {
           itemAmount = double.parse(value);
         } 
         catch(e) {
           itemAmount = 0.0;
         }
        });
      },
    );


    Container container = new Container(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
            children: [
              subTotalText,
              Padding(padding: EdgeInsets.only(top: 15),),
              Container( 
                alignment: Alignment(0.0, 0.0),
                child: Row(children: <Widget>[
                  Expanded( 
                    flex: 10,
                    child: itemField,
                  ),
                ],),
              ),
            ]));

    AppBar appBar = new AppBar(title: new Text("Split by person"), backgroundColor: Colors.red,);

    Scaffold scaffold = new Scaffold(appBar: appBar, body: SingleChildScrollView(child: container,));
    return scaffold;
  }
}

class SplitBillScreen extends StatefulWidget {
  final Map splitData;

  SplitBillScreen({Key key, @required this.splitData}) : super(key: key);

  @override
  SplitBillScreenState createState() => SplitBillScreenState();
}
