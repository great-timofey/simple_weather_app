import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_weather_app/models/models.dart';
import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/scenes/add_city_scene.dart';
import 'package:simple_weather_app/components/city_tile.dart';

class HomeScene extends StatefulWidget {
  HomeScene({Key key}) : super(key: key);

  @override
  HomeSceneState createState() => HomeSceneState();
}

class HomeSceneState extends State<HomeScene> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<Map<String, String>> _citiesData;
  var _currentLocation;
  var _cities;

  @override
  void initState() {
    super.initState();
    _citiesData = _prefs.then((SharedPreferences prefs) {
      final Set<String> keys = prefs.getKeys();
      Map<String, String> citiesData = Map.fromIterable(
        keys,
        key: (city) => city,
        value: (city) => prefs.getString(city),
      );
      return citiesData;
    });
    _cities = getCities(_citiesData);
    getLocation();
  }

  List<Widget> _renderCities(citiesToRender) => citiesToRender
      .map<Widget>(
        (city) => CityTile(city),
      )
      .toList();

  getCities(Future<Map<String, String>> citiesMap) async {
    final List<Future> futureCities = [];
    final cities = await citiesMap;
    cities.forEach((name, coords) => futureCities.add(getCity(name, coords)));
    final resultCities = await Future.wait(futureCities);
    return resultCities;
  }

  getCity(String name, String coordinates) async {
    final forecastRawData = await http
        .get('$darkskyPrefix/$darkskyApiKey/$coordinates?units=si')
        .then((res) => json.decode(res.body));
    final forecast = Forecast.fromJson(forecastRawData);
    final city = City(name, forecast);
    return city;
  }

  void getLocation() async {
    try {
      Location _locationProvider = Location();
      _currentLocation = await _locationProvider.getLocation();
    } catch (e) {
      _currentLocation = null;
    }
    print('current location is $_currentLocation');
  }

  String formatLocation() {
    num lat = _currentLocation['latitude'];
    num lon = _currentLocation['longitude'];
    return '$lat,$lon';
  }

  void onCityAdd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('Moscow', '55.7558,37.6173');
    await prefs.setString('Dubai', '25.2048,55.2708');
    await prefs.setString('Prague', '50.0755,14.4378');
    await prefs.setString('Murmansk', '68.9585,33.0827');
    if (_currentLocation != null) {
      await prefs.setString('SOMEWHERE', formatLocation());
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCityScene()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Weather App'),
      ),
      body: FutureBuilder(
          future: _cities,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Text('error ${snapshot.error}');
                else
                  return ListView(
                    children: _renderCities(snapshot.data),
                  );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: onCityAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}
