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
    return RaisedButton(
      onPressed: () => onCityChoose(name, cityKey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
