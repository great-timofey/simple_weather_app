import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const darkskyApiKey = 'aa18e7c611180393a4490b64424214e2';
const darkskyPrefix = 'https://api.darksky.net/forecast';
const teleportPrefix = 'https://api.teleport.org/api/urban_areas';
const cityCoverNotExists =
    'https://api.icons8.com/download/4419d1ec1dca6b200e6fb61ddefbe620131d2b66/iOS7/PNG/512/Very_Basic/search-512.png';

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
  };

  final resultCities = await getCities(cities);
  runApp(MyApp(resultCities));
}

class City {
  final String name;
  final Forecast forecast;

  City(this.name, this.forecast);

  @override
  String toString() => '$name : $forecast';
}

class Forecast {
  List<String> now = [];
  List<String> hourly = [];
  List<String> daily = [];

  String get currentTemp => now[0];
  String get currentForecast => now[1];
  String get hourlyTemp => hourly[0];
  String get hourlyForecast => hourly[1];
  String get dailyMinTemp => daily[0];
  String get dailyMaxTemp => daily[1];

  Forecast(this.now, this.hourly, this.daily);
  Forecast.fromJson(Map<String, dynamic> rawForecast) {
    this.now = List.from(now)
      ..add(rawForecast['currently']['temperature'].toString())
      ..add(rawForecast['currently']['summary']);
    this.hourly = List.from(hourly)
      ..add(rawForecast['hourly']['data'][0]['temperature'].toString())
      ..add(rawForecast['hourly']['data'][0]['summary']);
    this.daily = List.from(daily)
      ..add(rawForecast['daily']['data'][0]['temperatureLow'].toString())
      ..add(rawForecast['daily']['data'][0]['temperatureHigh'].toString());
  }

  @override
  String toString() {
    return '$now - $hourly - $daily';
  }
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
      home: MyHomePage(
        cities: cities,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final cities;
  MyHomePage({this.cities});

  String renderTemperature(String temperature) {
    final temperatureDouble = double.parse(temperature);
    print(temperature);
    return (temperatureDouble > 0 ? '+' : '-') +
        temperature.substring(
            0,
            (temperature.length > 4
                ? temperature.length - 1
                : temperature.length));
  }

  List<Widget> _renderCities(citiesToRender) => citiesToRender
      .map<Widget>(
        (city) => ExpansionTile(
              title: Container(
                child: Column(
                  children: [
                    Text(city.name,
                        style: TextStyle(
                            fontSize: 35.0, fontWeight: FontWeight.w700)),
                    Text(city.forecast.currentForecast,
                        style: TextStyle(
                            fontSize: 18.0, fontStyle: FontStyle.italic))
                  ],
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(renderTemperature(city.forecast.currentTemp),
                    style:
                        TextStyle(fontSize: 35.0, fontWeight: FontWeight.w900)),
              ),
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text('Hourly:')),
                            Column(children: [
                              Text(city.forecast.hourlyForecast),
                              Text(renderTemperature(city.forecast.hourlyTemp))
                            ])
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text('Daily:')),
                            Column(children: [
                              Text(
                                  'min ${renderTemperature(city.forecast.dailyMinTemp)}'),
                              Text(
                                  'max ${renderTemperature(city.forecast.dailyMaxTemp)}'),
                            ])
                          ],
                        )
                      ],
                    ))
              ],
            ),
      )
      .toList();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Weather App'),
      ),
      body: ListView(children: _renderCities(cities)),
    );
  }
}
