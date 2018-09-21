import 'dart:async';
import 'dart:collection';
import 'dart:convert' show json;

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherBloc {
  List<City> _cities = [];
  Future<Map<String, String>> _citiesData;
  final _citiesSubject = BehaviorSubject<List<City>>();
  Stream<List<City>> get cities => _citiesSubject.stream;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  WeatherBloc() {
    _getCities(_citiesData);
    _citiesSubject.add(_cities);

    _citiesData = _prefs.then((SharedPreferences prefs) {
      final Set<String> keys = prefs.getKeys();
      Map<String, String> citiesData = Map.fromIterable(
        keys,
        key: (city) => city,
        value: (city) => prefs.getString(city),
      );
      return citiesData;
    });
  }

  _getCities(Future<Map<String, String>> citiesMap) async {
    final List<Future> futureCities = [];
    await citiesMap.then((cities) => cities
        .forEach((name, coords) => futureCities.add(_getCity(name, coords))));
    final resultCities = await Future.wait(futureCities);
    _cities = resultCities;
    print(_cities);
    // return resultCities;
  }

  _getCity(String name, String coordinates) async {
    final forecastRawData = await http
        .get('$darkskyPrefix/$darkskyApiKey/$coordinates?units=si')
        .then((res) => json.decode(res.body));
    final forecast = Forecast.fromJson(forecastRawData);
    final city = City(name, forecast);
    return city;
  }

  String _formatLocation() {
    // num lat = _currentLocation['latitude'];
    // num lon = _currentLocation['longitude'];
    // return '$lat,$lon';
  }

  void onCityAdd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('Moscow', '55.7558,37.6173');
    await prefs.setString('Dubai', '25.2048,55.2708');
    await prefs.setString('Prague', '50.0755,14.4378');
    await prefs.setString('Murmansk', '68.9585,33.0827');
    // // if (_currentLocation != null) {
    await prefs.setString('somewhere', _formatLocation());
    // }
  }

  void onCityRemove(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(cityName);
    // try {
    await prefs.remove(cityName);
    // print(_cities);
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('$cityName was successfully deleted'),
    //   ),
    // );
    // print('removed $cityName');
    // } catch (e) {
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: Colors.red,
    //     content: Text('$cityName was successfully deleted'),
    //   ),
    // );
    // print(e);
    // }
  }
}
