import 'package:flutter/material.dart';
import '../widgets/person_shared_dialog.dart';

class BillPersonItem {
  final int index;
  final String name;
  double toPayAmount;

  BillPersonItem(this.name, this.index);

  set updateAmount(double amount) {
    this.toPayAmount = amount;
  }

  get currentAmount {
    if (this.toPayAmount == null) {
      return 0;
    }
    else {
      return this.toPayAmount;
    }
  }
}

class BillItem {
  final int billPersonId;
  final double amount;

  BillItem(this.billPersonId, this.amount);
}

class SplitBillScreenState extends State<SplitBillScreen> {
  double itemAmount = 0.0;

  final TextEditingController _itemTextFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _itemTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<BillItem>> billItems = new List<List<BillItem>>();
    Set<int> whoSharedItem = new Set<int>();
    double subTotalAmount = widget.splitData["subTotalAmount"];
    final double serviceChargeAmount = widget.splitData["serviceChargeAmount"];
    final double taxAmount = widget.splitData["taxAmount"];
    double remainingAmount = subTotalAmount;

    double computeAmountToAdd() {
      var serviceCharge = itemAmount * (serviceChargeAmount/100);
      var taxCharge = (itemAmount + serviceCharge) * (taxAmount/100);
      print(itemAmount);
      print(serviceCharge);
      print(taxCharge);
      return (itemAmount + serviceCharge + taxCharge);
    }

    void updateAmounts() {
      print('updating amounts');
      setState(() {
        List<BillItem> tempBillItems = List<BillItem>();
        double amountToCharge = (computeAmountToAdd() / whoSharedItem.length);

        var newItems = widget.billPeopleItems.map((billPersonItem) {
          if (whoSharedItem.contains(billPersonItem.index)) {
            billPersonItem.updateAmount = billPersonItem.currentAmount + amountToCharge;
            BillItem billItem = BillItem(billPersonItem.index, amountToCharge);
            tempBillItems.add(billItem);
          }

          return billPersonItem;
        }).toList();
        widget.billPeopleItems.replaceRange(0, widget.billPeopleItems.length-1, newItems);

        billItems.add(tempBillItems);

        print("number of people items:");
        print(widget.billPeopleItems.length);
        print("---");
        print(tempBillItems.map((a) => a.amount));
        print(billItems.map((a) => a.map((b) => b.amount)));

        itemAmount = 0.0;
        whoSharedItem = Set<int>(); 
      });

      _itemTextFieldController.clear();
    }

    TextField itemField = new TextField(
      controller: _itemTextFieldController,
      decoration: new InputDecoration(
        labelText: "Receipt Item", 
        labelStyle: TextStyle(fontSize: 20),
        suffix: IconButton(
          icon: Icon(Icons.add), 
          color: Colors.red,
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context) {
              return PersonSharedDialog(
                peopleSharing: widget.billPeopleItems,
                selectedPeopleSharing: whoSharedItem,
                onSelectedPeopleSharing: (selectedPeople) {
                  whoSharedItem = selectedPeople;
                  print(whoSharedItem);
                },
                onConfirmAdd: (hasConfirmed) {
                  if(hasConfirmed && whoSharedItem.length >= 1 && itemAmount > 0) {
                    print('confirmed');
                    updateAmounts();
                  }
                  else {
                    print("Check the item value or select at least one person who will be paying for this shit.");
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


    Container container = new Container(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
            children: [
              Text("Subtotal is " + remainingAmount.toStringAsFixed(2), style: TextStyle(fontSize: 20)),
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
  final List<BillPersonItem> billPeopleItems = List<BillPersonItem>();
  final Map splitData;

  SplitBillScreen({this.splitData}) {
    for(var i=0; i < splitData['personCount']; i++) {
      String name = "Person " + (i+1).toString();
      this.billPeopleItems.add(BillPersonItem(name, i),);
    }
  }

  @override
  SplitBillScreenState createState() => SplitBillScreenState();
}
