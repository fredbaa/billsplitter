import 'package:flutter/material.dart';

class PersonSharedDialogState extends State<PersonSharedDialog> {
  Set<String> tempSelectedPeopleSharing;

  void initState() {
    tempSelectedPeopleSharing = widget.selectedPeopleSharing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Container dialogCheckboxes = Container(
      child: Column(children: widget.peopleSharing.map((personName) {
        return new CheckboxListTile(
          title: Text(personName),
          value: tempSelectedPeopleSharing.contains(personName),
          onChanged: (bool value) {
            setState(() {
              if (value) {
                tempSelectedPeopleSharing.add(personName);
              }
              else {
                tempSelectedPeopleSharing.remove(personName);
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
      content: dialogCheckboxes,
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

          },
        )
      ],
    );

    return alertDialog;
  }
}

class PersonSharedDialog extends StatefulWidget {
  final List<String> peopleSharing;
  final Set<String> selectedPeopleSharing;
  final ValueChanged<Set<String>> onSelectedPeopleSharing;

  PersonSharedDialog({
    this.peopleSharing,
    this.selectedPeopleSharing,
    this.onSelectedPeopleSharing
  });

  @override
  PersonSharedDialogState createState() => PersonSharedDialogState();
}
