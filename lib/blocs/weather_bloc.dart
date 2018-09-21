import 'dart:async';
import 'dart:convert' show json;

import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherBloc {
  List<City> _cities = [];
  Map<String, String> _citiesData;
  Map<String, double> _currentLocation;
  final _citiesSubject = BehaviorSubject<List<dynamic>>();
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  Stream<List<dynamic>> get cities => _citiesSubject.stream;

  WeatherBloc() {
    // print('bloc started');
    _isLoadingSubject.add(true);
    _getCities();
    _getLocation();
  }

  _getCities() async {
    await _prefs.then((SharedPreferences prefs) {
      final Set<String> keys = prefs.getKeys();
      Map<String, String> citiesData = Map.fromIterable(
        keys,
        key: (city) => city,
        value: (city) => prefs.getString(city),
      );
      _citiesData = citiesData;
    });

    final List<Future> futureCities = [];
    _citiesData
        .forEach((name, coords) => futureCities.add(_getCity(name, coords)));
    final List<City> resultCities = List.from(await Future.wait(futureCities));

    _cities = resultCities;
    _citiesSubject.add((_cities));
    _isLoadingSubject.add(false);
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
    num lat = _currentLocation['latitude'];
    num lon = _currentLocation['longitude'];
    return '$lat,$lon';
  }

  void _getLocation() async {
    try {
      Location _locationProvider = Location();
      _currentLocation = await _locationProvider.getLocation();
    } catch (e) {
      _currentLocation = null;
    }
    // print('current location is $_currentLocation');
  }

  void addCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Moscow', '55.7558,37.6173');
    await prefs.setString('Dubai', '25.2048,55.2708');
    await prefs.setString('Prague', '50.0755,14.4378');
    await prefs.setString('Murmansk', '68.9585,33.0827');
    if (_currentLocation != null) {
      await prefs.setString('somewhere', _formatLocation());
    }
  }

  void removeCity(String cityName) async {
    _isLoadingSubject.add(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(cityName);
    _getCities();
  }
}
