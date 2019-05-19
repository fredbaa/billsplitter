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
      child: Column(children: widget.peopleSharing.keys.map((personIndex) {
        Map personItem = widget.peopleSharing[personIndex];
        String personName = personItem['name'];
        return new CheckboxListTile(
          title: Text(personName),
          value: tempSelectedPeopleSharing.contains(personIndex),
          onChanged: (bool value) {
            setState(() {
              if (value) {
                tempSelectedPeopleSharing.add(personIndex);
              }
              else {
                tempSelectedPeopleSharing.remove(personIndex);
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
  final Map peopleSharing;
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
