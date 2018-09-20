import 'package:flutter/material.dart';

import 'package:simple_weather_app/components/city_tile.dart';

class HomeScene extends StatelessWidget {
  final cities;
  HomeScene({this.cities});

  List<Widget> _renderCities(citiesToRender) => citiesToRender
      .map<Widget>(
        (city) => CityTile(city),
      )
      .toList();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Weather App'),
      ),
      body: ListView(
        children: _renderCities(cities),
      ),
    );
  }
}
