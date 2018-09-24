import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/material.dart';

import 'package:simple_weather_app/utils/utils.dart';
import 'package:simple_weather_app/blocs/weather_bloc.dart';
import 'package:simple_weather_app/components/add_city_card.dart';

class AddCityScene extends StatefulWidget {
  WeatherBloc bloc;
  AddCityScene({this.bloc, Key key}) : super(key: key);

  @override
  _AddCitydSceneState createState() => _AddCitydSceneState();
}

class _AddCitydSceneState extends State<AddCityScene> {
  String _newCity;
  List<String> _cities = [];
  final TextEditingController _controller = TextEditingController();

  Widget _buildItem(suggestion) => AddCityCard(
        name: suggestion['LocalizedName'],
        chooseCity: _handleChooseCity,
      );

  void _handleInputClear() {
    _cities.clear();
    _controller.clear();
    print(_cities);
  }

  void _handleChooseCity(String chosenCity) {
    _newCity = chosenCity;
    print(_newCity);
  }

  void _handleChangeInput(String input) {
    widget.bloc.searchCities(_controller.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Stack(
            children: [
              TextField(
                controller: _controller,
                onChanged: _handleChangeInput,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5.0),
                    ),
                  ),
                  hintText: 'City you want to add...',
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              Positioned(
                right: 0.0,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.blue,
                  ),
                  onPressed: _handleInputClear,
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: widget.bloc.isLoading,
            builder: (context, snapshot) {
              return snapshot.data == true
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder(
                      stream: widget.bloc.suggestions,
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
        ));
  }
}
