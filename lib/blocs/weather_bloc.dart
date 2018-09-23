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
    print('bloc started');
    _isLoadingSubject.add(true);
    _getCitiesFromPrefs().then((_) => _getCitiesFromApi());
    _getLocation();
  }

  Future<Null> _getCitiesFromApi() async {
    final List<Future> futureCities = [];
    _persistedCities.forEach((cityName, locationKey) =>
        futureCities.add(_getCity(cityName, locationKey)));
    final List<City> resultCities = List.from(await Future.wait(futureCities));

    _cities = resultCities;
    _citiesSubject.add(_cities);
    _isLoadingSubject.add(false);
  }

  Future<Null> _getCitiesFromPrefs() async {
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

  Future<City> _getCity(String cityName, String locationKey) async {
    final rawCurrentForecast = await http
        .get(
            '$accuweatherPrefix/currentconditions/v1/$locationKey?apikey=$accuweatherApiKey')
        .then((res) => json.decode(res.body));

    final rawNext5DaysForecast = await http
        .get(
            '$accuweatherPrefix/forecasts/v1/daily/5day/$locationKey?apikey=$accuweatherApiKey&metric=true')
        .then((res) => json.decode(res.body));
    final rawNext12HoursForecast = await http
        .get(
            '$accuweatherPrefix/forecasts/v1/hourly/12hour/$locationKey?apikey=$accuweatherApiKey&metric=true')
        .then((res) => json.decode(res.body));

    final forecast = Forecast.fromJson(
      rawCurrentForecast[0],
      rawNext12HoursForecast,
      rawNext5DaysForecast,
    );
    final city = City(cityName, forecast);
    print(city);
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
    SharedPreferences refreshedPrefs = await SharedPreferences.getInstance();
    await refreshedPrefs.clear();
    refreshedPrefs.setString('New York', '349727');
  }

  void removeCity(String cityName) async {
    SharedPreferences prefs = await _prefs;
    await prefs.remove(cityName);
    _cities.remove(_cities.firstWhere((city) => city.name == cityName));
    _citiesSubject.add(_cities);
    // _citiesSubject.listen((onData) => print(_cities));
  }
}
