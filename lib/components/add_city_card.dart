import 'package:flutter/material.dart';

@immutable
class AddCityCard extends StatelessWidget {
  final String name;
  final String country;
  final String cityKey;
  final Function onCityChoose;
  AddCityCard({this.name, this.cityKey, this.country, this.onCityChoose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: RaisedButton(
                onPressed: () => onCityChoose(name, cityKey),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '$name : $country',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ))),
          ),
        ),
      ],
    );
  }
}
