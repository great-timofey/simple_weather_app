import 'package:flutter/material.dart';

class AddCityCard extends StatelessWidget {
  final String _name;
  AddCityCard(this._name);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: RaisedButton(
                onPressed: () {
                  print(_name);
                },
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'here goes $_name city',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ))),
          ),
        ),
      ],
    );
  }
}
