import 'package:flutter/material.dart';

import 'package:simple_weather_app/models/models.dart';

class CityTile extends StatelessWidget {
  final City city;
  final Function onDismiss;
  CityTile(this.city, this.onDismiss);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // color: Colors.lightBlue[100],
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(
            'https://classconnection.s3.amazonaws.com/502/flashcards/2651502/jpg/cirrus_clouds2-1449CE3484F74DFCE50-thumb400.jpg'),
        fit: BoxFit.fitWidth,
      )),
      child: Dismissible(
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
        onDismissed: (_) {
          onDismiss(city.name);
        },
        child: ExpansionTile(
          trailing: Container(
            child: Text(
              'bal',
              // city.forecast.currentTemp,
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w900,
                // color: Colors.white,
              ),
            ),
          ),
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.w700,
                        // color: Colors.white,
                      ),
                    ),
                    Text(
                      'sdf',
                      // city.forecast.currentForecast,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                        // color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: <Widget>[
            Container(
              // padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text('Hourly:')),
                      Column(children: [
                        // Text(city.forecast.hourlyForecast),
                        // Text(city.forecast.hourlyTemp)
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
                        // Text('min ${city.forecast.dailyMinTemp}'),
                        // Text('max ${city.forecast.dailyMaxTemp}'),
                      ])
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
