import 'dart:async';
import 'dart:convert' show json;

import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/models/models.dart';

class WeatherBloc {
  var suggestionsStream;
  List<City> _cities = [];
  List<dynamic> _suggestions = [];
  Map<String, String> _persistedCities;
  Map<String, double> _currentLocation;
  final suggestionsSink = PublishSubject<String>();
  final _citiesSubject = BehaviorSubject<List<City>>();
  final _suggestionsSubject = BehaviorSubject<List<dynamic>>();
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  Stream<List<City>> get cities => _citiesSubject.stream;
  Stream<List<dynamic>> get suggestions => _suggestionsSubject.stream;

  WeatherBloc() {
    print('bloc started');
    _isLoadingSubject.add(true);
    _getCitiesFromPrefs().then((_) => _getCitiesFromApi());
    _getLocation();
    _subscribeOnAutocompletion();
  }

  void _subscribeOnAutocompletion() {
    suggestionsStream = suggestionsSink
        .distinct()
        .debounce(const Duration(milliseconds: 1000))
        .listen((req) => _searchCities(req));
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
    final rawCurrentForecast = json.decode(fakeCurrentReq);
    // final rawCurrentForecast = await http
    //     .get(
    //         '$accuweatherPrefix/currentconditions/v1/$locationKey?apikey=$accuweatherApiKey')
    //     .then((res) => json.decode(res.body));

    final rawNext5DaysForecast = json.decode(fakeNext5DaysReq);
    // final rawNext5DaysForecast = await http
    //     .get(
    //         '$accuweatherPrefix/forecasts/v1/daily/5day/$locationKey?apikey=$accuweatherApiKey&metric=true')
    //     .then((res) => json.decode(res.body));

    final rawNext12HoursForecast = json.decode(fakeNext12HoursReq);
    // final rawNext12HoursForecast = await http
    //     .get(
    //         '$accuweatherPrefix/forecasts/v1/hourly/12hour/$locationKey?apikey=$accuweatherApiKey&metric=true')
    //     .then((res) => json.decode(res.body));

    final forecast = Forecast.fromJson(
      rawCurrent: rawCurrentForecast[0],
      rawNext5Days: rawNext5DaysForecast,
      rawNext12Hours: rawNext12HoursForecast,
    );

    final city = City(cityName, forecast);

    // print(city);
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

  _searchCities(String request) async {
    _isLoadingSubject.add(true);
    if (request is String && request.length > 0) {
      // final rawRes = await http
      //     .get(
      //         '$accuweatherPrefix/locations/v1/cities/autocomplete?apikey=$accuweatherApiKey&q=$request')
      //     .then((res) => json.decode(res.body));

      json
          // rawRes
          .decode(fakeAutocompletionReq)
          .forEach((item) => _suggestions.add(_getSuggestion(item)));
      // print(_suggestions);
      _suggestionsSubject.add(_suggestions);
    } else {
      _suggestions.clear();
    }
    _isLoadingSubject.add(false);
  }

  Map<String, String> _getSuggestion(Map<String, dynamic> source) {
    Map<String, String> result = {};
    List<String> filters = ['LocalizedName', 'Key', 'Country'];
    result = Map.fromIterable(
      source.keys.where((key) => filters.contains(key)),
      value: (key) {
        final current = source[key];
        switch (key) {
          case ('Country'):
            return current['LocalizedName'];
          default:
            return current;
        }
      },
    );
    // print(result);

    return result;
  }

  void addCity(String name, String key) async {
    SharedPreferences refreshedPrefs = await SharedPreferences.getInstance();
    // await refreshedPrefs.clear();
    // refreshedPrefs.setString('New York', '349727');
    refreshedPrefs.setString(name, key);
    // print(refreshedPrefs.getKeys());
    _getCitiesFromPrefs().then((_) => _getCitiesFromApi());
    _citiesSubject.add(_cities);
  }

  void removeCity(String cityName) async {
    SharedPreferences prefs = await _prefs;
    await prefs.remove(cityName);
    _cities.remove(_cities.firstWhere((city) => city.name == cityName));
    _citiesSubject.add(_cities);
  }
}
