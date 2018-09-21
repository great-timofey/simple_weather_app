import 'dart:async';
import 'dart:convert' show json;

import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/models/models.dart';

class WeatherBloc {
  List<City> _cities = [];
  Map<String, String> _persistedCities;
  Map<String, double> _currentLocation;
  final _citiesSubject = BehaviorSubject<List<City>>();
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  Stream<List<City>> get cities => _citiesSubject.stream;

  WeatherBloc() {
    // print('bloc started');
    _isLoadingSubject.add(true);
    _getCitiesFromPrefs().then((_) => _getCitiesFromApi());
    _getLocation();
  }

  _getCitiesFromApi() async {
    final List<Future> futureCities = [];
    _persistedCities
        .forEach((name, coords) => futureCities.add(_getCity(name, coords)));
    final List<City> resultCities = List.from(await Future.wait(futureCities));

    _cities = resultCities;
    _citiesSubject.add(_cities);
    _isLoadingSubject.add(false);
  }

  _getCitiesFromPrefs() async {
    SharedPreferences prefs = await _prefs;
    final Set<String> keys = prefs.getKeys();
    _convertPrefsToPersistedCities(
      keys,
      prefs,
    );
  }

  void _convertPrefsToPersistedCities(
      Set<String> keys, SharedPreferences prefs) {
    Map<String, String> persistedCities = Map.fromIterable(
      keys,
      key: (city) => city,
      value: (city) => prefs.getString(city),
    );
    _persistedCities = persistedCities;
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
    print('current location is $_currentLocation');
  }

  void addCity() async {
    if (_cities.length != _persistedCities.length) {
      _isLoadingSubject.add(true);
      SharedPreferences refreshedPrefs = await SharedPreferences.getInstance();
      final Set<String> refreshedKeys = refreshedPrefs.getKeys();
      final List<Future> citiesToUpdate = [];
      refreshedKeys.map((key) {
        if (_persistedCities.containsKey(key) == false)
          citiesToUpdate.add(
              refreshedPrefs.setString(key, refreshedPrefs.getString(key)));
      });
      await Future.wait(citiesToUpdate);
      _convertPrefsToPersistedCities(
        refreshedKeys,
        refreshedPrefs,
      );
      _getCitiesFromApi();
      // await prefs.setString('Moscow', '55.7558,37.6173');
      // await prefs.setString('Dubai', '25.2048,55.2708');
      // await prefs.setString('Prague', '50.0755,14.4378');
      // await prefs.setString('Murmansk', '68.9585,33.0827');
      if (_currentLocation != null) {
        // await prefs.setString('somewhere', _formatLocation());
      }
    }
  }

  void removeCity(String cityName) async {
    SharedPreferences prefs = await _prefs;
    await prefs.remove(cityName);
    _cities.remove(_cities.firstWhere((city) => city.name == cityName));
    _citiesSubject.add(_cities);
    // _citiesSubject.listen((onData) => print(_cities));
  }
}
