import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:simple_weather_app/models/models.dart';

class CityTile extends StatelessWidget {
  final City city;
  final Function onDismiss;
  CityTile(this.city, this.onDismiss);

  Widget _buildDaily(item, index, isLast) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            right: !isLast ? BorderSide.none : BorderSide(color: Colors.blue)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
              index == 0
                  ? 'Today'
                  : DateFormat('EEEE')
                      .format(DateTime.now().add(Duration(days: 1 * index))),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Text('Max: ' + item['Temperature']['Maximum'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              )),
          Text('Min: ' + item['Temperature']['Minimum'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget _buildHourly(item, index, isLast) => Container(
        decoration: BoxDecoration(
          border: Border(
              right:
                  !isLast ? BorderSide.none : BorderSide(color: Colors.blue)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text((DateTime.now().hour + index).toString() +
                ':' +
                DateTime.now().minute.toString()),
            Text(item['Temperature'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      );

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
            backgroundColor: Colors.white,
            trailing: Container(
              child: Text(
                // 'bal',
                city.forecast.current['Temperature']['Metric'] + ' C',
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
                        // 'sdf',
                        city.forecast.current['WeatherText'],
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
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Hourly Forecasts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: (Border(
                    top: BorderSide(color: Colors.blue),
                    bottom: BorderSide(color: Colors.blue),
                  )),
                ),
                height: 50.0,
                child: ListView.builder(
                  itemCount: city.forecast.hourlyForecasts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => index ==
                          city.forecast.hourlyForecasts.length - 1
                      ? _buildHourly(
                          city.forecast.hourlyForecasts[index], index, false)
                      : _buildHourly(
                          city.forecast.hourlyForecasts[index], index, true),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Daily Forecasts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: (Border(
                    top: BorderSide(color: Colors.blue),
                    bottom: BorderSide(color: Colors.blue),
                  )),
                ),
                height: 200.0,
                child: ListView.builder(
                  itemCount: city.forecast.daily['DailyForecasts'].length,
                  itemBuilder: (context, index) =>
                      index == city.forecast.daily['DailyForecasts'].length - 1
                          ? _buildDaily(
                              city.forecast.daily['DailyForecasts'][index],
                              index,
                              false)
                          : _buildDaily(
                              city.forecast.daily['DailyForecasts'][index],
                              index,
                              true),
                ),
              ),
            ],
          )),
    );
  }
}
