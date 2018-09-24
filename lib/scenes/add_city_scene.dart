import 'package:flutter/material.dart';

import 'package:simple_weather_app/blocs/weather_bloc.dart';
import 'package:simple_weather_app/components/add_city_card.dart';

class AddCityScene extends StatefulWidget {
  final WeatherBloc bloc;
  AddCityScene({this.bloc, Key key}) : super(key: key);

  @override
  _AddCitydSceneState createState() => _AddCitydSceneState();
}

class _AddCitydSceneState extends State<AddCityScene> {
  final TextEditingController _controller = TextEditingController();

  Widget _buildItem(suggestion) => AddCityCard(
        name: suggestion['LocalizedName'],
        country: suggestion['Country'],
        cityKey: suggestion['Key'],
        onCityChoose: _handleChooseCity,
      );

  void _handleInputClear() {
    _controller.clear();
    widget.bloc.suggestionsSink.add('');
  }

  void _handleChooseCity(String name, String cityKey) {
    widget.bloc.addCity(name, cityKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: () {
              widget.bloc.suggestionsSink.add('');
              Navigator.of(context).pop();
            },
          ),
          title: Stack(
            children: [
              TextField(
                controller: _controller,
                onChanged: widget.bloc.suggestionsSink.add,
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
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return _buildItem(snapshot.data[index]);
                          },
                        );
                      },
                    );
            },
          ),
        ));
  }
}
