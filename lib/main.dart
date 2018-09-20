import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:simple_weather_app/models/models.dart';
import 'package:simple_weather_app/scenes/home_scene.dart';
import 'package:simple_weather_app/utils/utils.dart';

getCities(Map<String, String> citiesMap) async {
  final List<Future> futureCities = [];
  citiesMap.forEach((name, coords) => futureCities.add(getCity(name, coords)));
  final resultCities = await Future.wait(futureCities);
  return resultCities;
}

getCity(String name, String coordinates) async {
  final forecastRawData = await http
      .get('$darkskyPrefix/$darkskyApiKey/$coordinates?units=auto')
      .then((res) => json.decode(res.body));
  final forecast = Forecast.fromJson(forecastRawData);
  final city = City(name, forecast);
  return city;
}

// getCityCover(String city) async {
//   try {
//     List<String> result = [];
//     final coverRaw = await http
//         .get('$teleportPrefix/slug:$city/images')
//         .then((res) => json.decode(res.body));
//     final photos = coverRaw['photos'];
//     for (var photo in photos) result.add(photo['image']['mobile']);
//     return result;
//   } catch (e) {
//     return [];
//   }
// }

void main() async {
  const cities = {
    'Moscow': '55.7558,37.6173',
    'Dubai': '25.2048,55.2708',
    'Prague': '50.0755,14.4378',
    'Murmansk': '68.9585,33.0827',
  };

  final resultCities = await getCities(cities);
  runApp(MyApp(resultCities));
}

class MyApp extends StatelessWidget {
  final cities;
  MyApp(this.cities);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScene(
        cities: cities,
      ),
    );
  }
}
