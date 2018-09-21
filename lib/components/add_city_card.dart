import 'package:flutter/material.dart';

@immutable
class AddCityCard extends StatelessWidget {
  final String name;
  final Function chooseCity;
  AddCityCard({this.name, this.chooseCity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: RaisedButton(
                onPressed: () => chooseCity(name),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      name,
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
