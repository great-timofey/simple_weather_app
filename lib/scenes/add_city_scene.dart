import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/components/add_city_card.dart';

class AddCityScene extends StatefulWidget {
  AddCityScene({Key key}) : super(key: key);

  @override
  _AddCitydSceneState createState() => _AddCitydSceneState();
}

class _AddCitydSceneState extends State<AddCityScene> {
  List<String> _cities = [];
  String _newCity;
  final TextEditingController _controller = TextEditingController();

  _renderCities(List<String> cities) {
    if (cities != null)
      return cities
          .map<Widget>(
              (city) => AddCityCard(name: city, chooseCity: _handleChooseCity))
          .toList();
    else
      return <Widget>[];
  }

  _searchCities(String city) async {
    // TODO: complete debounce logic
    print('called');
    // final citiesRes = await http
    //     .get(
    //         '$accuweatherPrefix/locations/v1/cities/autocomplete?apikey=$accuweatherApiKey&q=$city')
    //     .then((res) => json.decode(res.body));
    // print(citiesRes);
    // if (citiesRes != null) {
    //   int count = 0;
    //   while (_cities.length < 5) {
    //     _cities.add(citiesRes[count]['LocalizedName']);
    //     count++;
    //   }
    // }
  }

  void _handleInputClear() {
    _cities.clear();
    _controller.clear();
    print(_cities);
  }

  void _handleChooseCity(String chosenCity) {
    _newCity = chosenCity;
    print(_newCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            TextField(
              controller: _controller,
              onChanged: _searchCities,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(5.0),
                  ),
                ),
                hintText: 'City you want to add...',
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            Positioned(
              right: 0.0,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.blue,
                ),
                onPressed: _handleInputClear,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: _renderCities(['tokyo', 'tomsk'])),
      ),
    );
  }
}
