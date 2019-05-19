import 'package:flutter/material.dart';
import '../widgets/person_shared_dialog.dart';

class SplitBillScreenState extends State<SplitBillScreen> {
  final Map billPeople = {};
  final List billItems = new List();
  double itemAmount = 0.0;
  double remainingAmount = 0.0;
  String itemErrorText = "";

  final TextEditingController _itemTextFieldController = new TextEditingController();

  @override
  void initState() {
    print("init state");
    remainingAmount = widget.splitData["subTotalAmount"];
    for(var i=0; i < widget.splitData['personCount']; i++) {
      String name = "Person " + (i+1).toString();
      this.billPeople[i] = {"name": name, "amount": 0};
    }

    super.initState();
  }

  @override
  void dispose() {
    _itemTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double serviceChargeAmount = widget.splitData["serviceChargeAmount"];
    final double taxAmount = widget.splitData["taxAmount"];
    Set<int> whoSharedItem = new Set<int>();
    
    print('widget building');

    double computeAmountToAdd(amountToCompute) {
      var serviceCharge = amountToCompute * (serviceChargeAmount/100);
      var taxCharge = (amountToCompute + serviceCharge) * (taxAmount/100);
      return (amountToCompute + serviceCharge + taxCharge);
    }

    void updateAmounts() {
      print('updating amounts');
      setState(() {
        var computedCharge = computeAmountToAdd(itemAmount);
        var amountPerPerson = computedCharge / whoSharedItem.length;

        whoSharedItem.forEach((personIndex) {
          this.billPeople[personIndex]['amount'] += amountPerPerson;
        });

        this.billItems.add({"amount": itemAmount, "sharedBy": whoSharedItem});

        print(this.billPeople);
        print(this.billItems);

        remainingAmount -= itemAmount;

        print(remainingAmount);

        itemAmount = 0.0;
        whoSharedItem = Set<int>(); 
      });

      _itemTextFieldController.clear();
    }

    void removeLastBillItem(){
      if (this.billItems.length > 0) {
        setState(() {
          var lastItem = this.billItems.removeLast();
          var computedCharge = computeAmountToAdd(lastItem['amount']);
          var amountPerPerson = computedCharge / lastItem['sharedBy'].length; 
          remainingAmount += lastItem['amount'];

          print(amountPerPerson);
          print(lastItem['amount']);
          
          lastItem['sharedBy'].forEach((personIndex) {
            this.billPeople[personIndex]['amount'] -= amountPerPerson;
          });
        });
      }
    }

    TextField itemField = new TextField(
      controller: _itemTextFieldController,
      decoration: new InputDecoration(
        labelText: "Receipt Item", 
        labelStyle: TextStyle(fontSize: 25),
        suffix: IconButton(
          icon: Icon(Icons.add), 
          color: Colors.red,
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context) {
              return PersonSharedDialog(
                peopleSharing: this.billPeople,
                selectedPeopleSharing: whoSharedItem,
                onSelectedPeopleSharing: (selectedPeople) {
                  whoSharedItem = selectedPeople;
                  print(whoSharedItem);
                },
                onConfirmAdd: (hasConfirmed) {
                  if(hasConfirmed && whoSharedItem.length >= 1 && itemAmount > 0 && itemAmount <= remainingAmount) {
                    print('confirmed');
                    itemErrorText = "";
                    updateAmounts();
                  }
                  else {
                    itemErrorText = "Check the item value or select at least one person who will be paying for this shit.";
                  }
                }
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

    Container itemFieldContainer = Container( 
      alignment: Alignment(0.0, 0.0),
      child: Row(children: <Widget>[
        Expanded( 
          flex: 10,
          child: itemField,
        ),
      ],),
    );
    
    Container payablesContainer = Container( 
      alignment: Alignment(0.0, 0.0),
      child: Column( 
        children: this.billPeople.keys.map((personIndex) {
          var person = this.billPeople[personIndex];
          var personField = TextField(
            decoration: InputDecoration(border: InputBorder.none, hintText: person['name']),
            style: TextStyle(fontSize: 25, color: Colors.black, height: 1), 
            cursorColor: Colors.blueAccent,
            enableInteractiveSelection: true,
            onChanged: (value) {
              setState(() {
                var newName = value;

                if (newName.trim().length == 0)
                  newName = "Person " + (personIndex + 1).toString();

                this.billPeople[personIndex]['name'] = newName;
              });
            },);

          var personPayable = Text(
            this.billPeople[personIndex]['amount'].toStringAsFixed(2), 
            style: TextStyle(fontSize: 25, color: Colors.black, height: 1),
            );

          return Row(children: <Widget>[
            Expanded(child: personField, flex: 7),
            Expanded(child: personPayable, flex: 3,)
          ],);
        }).toList(),
      ),
    );

    Opacity helpText = Opacity(
      opacity: 1,
      child: Text(itemErrorText,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 15, color: Colors.redAccent),
      ),
    );

    var undoItemWidget = Opacity(
      opacity: this.billItems.length == 0 ? 0 : 1,
      child: IconButton(
        icon: Icon(Icons.undo),
        tooltip: "Undo last bill item",
        onPressed: (){
          removeLastBillItem();
        },),
    );

    Container container = new Container(
      padding: const EdgeInsets.all(15.0),
      child: new Column(
          children: <Widget>[
            Text("Remaining subtotal is " + remainingAmount.toStringAsFixed(2), style: TextStyle(fontSize: 20)),
            Padding(padding: EdgeInsets.only(top: 15),),
            itemFieldContainer,
            Padding(padding: EdgeInsets.only(top: 5),),
            helpText,
            Padding(padding: EdgeInsets.only(top: 7),),
            payablesContainer,
            Padding(padding: EdgeInsets.only(top: 3),)
          ]));

    AppBar appBar = new AppBar(
      title: new Text((widget.splitData['billName'] ?? "Untitled") + " Bill"), 
      backgroundColor: Colors.red,
      actions: <Widget>[
        undoItemWidget,
      ],
    );

    Scaffold scaffold = new Scaffold(appBar: appBar, body: SingleChildScrollView(child: container,));
    return scaffold;
  }
}

class SplitBillScreen extends StatefulWidget {
  final Map splitData;

  SplitBillScreen({this.splitData}) {
    print("initializing");
  }

  @override
  SplitBillScreenState createState() => SplitBillScreenState();
}
