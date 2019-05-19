import 'package:billsplitter/app_screens/split_bill_screen.dart';
import 'package:flutter/material.dart';

class PersonSharedDialogState extends State<PersonSharedDialog> {
  Set<int> tempSelectedPeopleSharing;
  bool confirmedAdd = false;

  void initState() {
    tempSelectedPeopleSharing = widget.selectedPeopleSharing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Container dialogCheckboxes = Container(
      child: Column(children: widget.peopleSharing.map((personItem) {
        String personName = personItem.name;
        return new CheckboxListTile(
          title: Text(personName),
          value: tempSelectedPeopleSharing.contains(personItem.index),
          onChanged: (bool value) {
            setState(() {
              if (value) {
                tempSelectedPeopleSharing.add(personItem.index);
              }
              else {
                tempSelectedPeopleSharing.remove(personItem.index);
              }
            });

            widget.onSelectedPeopleSharing(tempSelectedPeopleSharing);
          });
        }).toList(),
        mainAxisSize: MainAxisSize.min,
      )
    );
    
    AlertDialog alertDialog = AlertDialog(
      title: Text("Who shared this item?"),
      content: SingleChildScrollView(child: dialogCheckboxes,),
      actions: <Widget>[
        MaterialButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text("Add"),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            widget.onConfirmAdd(true);
            Navigator.pop(context);
          },
        )
      ],
    );

    return alertDialog;
  }
}

class PersonSharedDialog extends StatefulWidget {
  final List<BillPersonItem> peopleSharing;
  final Set<int> selectedPeopleSharing;
  final ValueChanged<Set<int>> onSelectedPeopleSharing;
  final ValueChanged<bool> onConfirmAdd;

  PersonSharedDialog({
    this.peopleSharing,
    this.selectedPeopleSharing,
    this.onSelectedPeopleSharing,
    this.onConfirmAdd
  });

  @override
  PersonSharedDialogState createState() => PersonSharedDialogState();
}
