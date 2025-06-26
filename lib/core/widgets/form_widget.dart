import 'package:flutter/material.dart';
import 'package:kebaby_brno/core/data/kebab_entry.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() {
    return _FormWidgetState();
  }
}

class _FormWidgetState extends State<FormWidget> {
  // A key for managing the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variable to store the entered name
  String _name = '';
  String _adress = '';
  String _type = '';
  int _price = 100;
  int? _discount;
  double _foodRating = 0;
  double _vibeRating = 0;
  String _notes = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      KebabEntry newEntry = KebabEntry(
        _name,
        _adress,
        _type,
        _price,
        _discount,
        _foodRating.toInt(),
        _vibeRating.toInt(),
        _notes,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Form Submitted"),

            content: Text(newEntry.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kebabový Formulář'),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.secondaryHeaderColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jméno Inšpektóra',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Prosím zadejte své jméno.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Adresa zkoumaného subjektu',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Prosím zadejte adresu prodejce.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _adress = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Typ Kebabu',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Prosím zadejte typ pojíného kebabu.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _type = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cena Kebabu v Kč',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Zadejte cenu kebabu.";
                        }
                        if (int.tryParse(value) == null) {
                          return "Pole musí být celočíselné";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _price = int.tryParse(value!)!;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Možná Sleva v Kč',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Zadejte možnou slevu.";
                        }
                        if (int.tryParse(value) == null) {
                          return "Pole musí být celočíselné";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _discount = int.tryParse(value!)!;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 80, child: Text("Rating Jídla: ")),
                  Expanded(
                    child: Slider(
                      value: _foodRating,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      // gives 0.1 steps
                      label: _foodRating.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() {
                          _foodRating = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 80, child: Text("Vibe rating: ")),
                  Expanded(
                    child: Slider(
                      value: _vibeRating,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      // gives 0.1 steps
                      label: _vibeRating.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() {
                          _vibeRating = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                onSaved: (value) {
                  _notes = value ?? '';
                },
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Poznámky',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.cardColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
