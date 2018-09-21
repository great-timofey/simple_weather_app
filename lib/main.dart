import 'package:flutter/material.dart';

import 'package:simple_weather_app/scenes/home_scene.dart';
import 'package:simple_weather_app/blocs/weather_bloc.dart';

void main() {
  final weatherBloc = WeatherBloc();
  runApp(MyApp(weatherBloc));
}

class MyApp extends StatelessWidget {
  final WeatherBloc bloc;

  MyApp(this.bloc);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScene(
        bloc: bloc,
      ),
    );
  }
}
