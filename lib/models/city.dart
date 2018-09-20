import 'package:simple_weather_app/models/forecast.dart';

class City {
  final String name;
  final Forecast forecast;

  City(this.name, this.forecast);

  @override
  String toString() => '$name : $forecast';
}
