// import 'dart:async';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:simple_weather_app/blocs/weather_bloc.dart';
import 'package:simple_weather_app/components/city_tile.dart';
import 'package:simple_weather_app/scenes/add_city_scene.dart';

class HomeScene extends StatefulWidget {
  HomeScene({Key key}) : super(key: key);

  @override
  HomeSceneState createState() => HomeSceneState();
}

class HomeSceneState extends State<HomeScene> {
  WeatherBloc bloc = WeatherBloc();
  Map<String, double> _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
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

  onCityAdd() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCityScene()));
  }

  onCityRemove() {}

  Widget _buildItem(city) => CityTile(city, onCityRemove);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Weather App'),
      ),
      body: StreamBuilder(
          // stream: cities,
          initialData: [],
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children: snapshot.data.map<Widget>(_buildItem).toList(),
                );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, //onCityAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}
