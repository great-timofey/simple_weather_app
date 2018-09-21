import 'package:flutter/material.dart';

import 'package:simple_weather_app/models/models.dart';

class CityTile extends StatelessWidget {
  final City city;
  final Function onDismiss;
  CityTile(this.city, this.onDismiss);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(city.name),
      direction: DismissDirection.startToEnd,
      background: Container(
          padding: EdgeInsets.only(left: 10.0),
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Delete',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  )),
            ],
          )),
      onDismissed: (direction) {
        // print(onDismiss);
        // print(city.name);
        onDismiss(city.name);
      },
      child: ExpansionTile(
        title: Container(
          child: Column(
            children: <Widget>[
              Text(city.name,
                  style:
                      TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700)),
              Text(city.forecast.currentForecast,
                  style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic))
            ],
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text(city.forecast.currentTemp,
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w900)),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text('Hourly:')),
                    Column(children: [
                      Text(city.forecast.hourlyForecast),
                      Text(city.forecast.hourlyTemp)
                    ])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text('Daily:')),
                    Column(children: [
                      Text('min ${city.forecast.dailyMinTemp}'),
                      Text('max ${city.forecast.dailyMaxTemp}'),
                    ])
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
