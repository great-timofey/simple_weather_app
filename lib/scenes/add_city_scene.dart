import 'package:flutter/material.dart';
import 'package:simple_weather_app/components/add_city_card.dart';

class AddCityScene extends StatefulWidget {
  AddCityScene({Key key}) : super(key: key);

  @override
  _AddCitydSceneState createState() => _AddCitydSceneState();
}

class _AddCitydSceneState extends State<AddCityScene> {
  List<String> _cities;

  _renderCities(List<String> cities) =>
      cities.map<Widget>((city) => AddCityCard(city)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(5.0),
              ),
            ),
            hintText: 'Enter city name...',
            contentPadding: EdgeInsets.all(15.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: _renderCities(['a', 'b'])),
      ),
    );
  }
}
