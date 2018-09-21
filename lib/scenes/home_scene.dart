import 'package:flutter/material.dart';

import 'package:simple_weather_app/blocs/weather_bloc.dart';
import 'package:simple_weather_app/components/city_tile.dart';
import 'package:simple_weather_app/scenes/add_city_scene.dart';

class HomeScene extends StatefulWidget {
  final WeatherBloc bloc;

  HomeScene({Key key, this.bloc}) : super(key: key);

  @override
  HomeSceneState createState() => HomeSceneState();
}

class HomeSceneState extends State<HomeScene> {
  @override
  void initState() {
    super.initState();
  }

  onCityAdd() {
    widget.bloc.addCity();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCityScene()));
  }

  onCityRemove(String cityName) {
    widget.bloc.removeCity(cityName);
  }

  Widget _buildItem(city) => CityTile(city, onCityRemove);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Weather App'),
      ),
      body: StreamBuilder(
        stream: widget.bloc.isLoading,
        builder: (context, snapshot) {
          return snapshot.data == true
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  stream: widget.bloc.cities,
                  initialData: [],
                  builder: (context, snapshot) {
                    return ListView.separated(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return _buildItem(snapshot.data[index]);
                        },
                        separatorBuilder: (_, index) {
                          return Divider(color: Colors.black, height: 0.0);
                        });
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCityAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}
