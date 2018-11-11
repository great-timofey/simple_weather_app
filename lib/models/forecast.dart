import 'package:meta/meta.dart';

class Forecast {
  List<dynamic> hourlyForecasts = List();
  Map<String, dynamic> currentConditions = Map();
  Map<String, dynamic> next5DaysForecasts = Map();

  Map<String, dynamic> get current => currentConditions;
  List<dynamic> get hourly => hourlyForecasts;
  Map<String, dynamic> get daily => next5DaysForecasts;

  Forecast.fromJson({
    @required Map<String, dynamic> rawCurrent,
    @required List<dynamic> rawNext12Hours,
    @required Map<String, dynamic> rawNext5Days,
  }) {
    this.currentConditions = getCurrentData(
        source: rawCurrent, filters: ['WeatherText', 'Temperature']);
    this.hourlyForecasts = getData(source: rawNext12Hours, hourly: true);
    this.next5DaysForecasts = getData(source: rawNext5Days, hourly: false);
  }

  Map<String, dynamic> getCurrentData({
    @required Map<String, dynamic> source,
    @required List<String> filters,
  }) {
    Map<String, dynamic> result;
    result = Map.fromIterable(
      source.keys.where((key) => filters.contains(key)),
      value: (key) {
        final current = source[key];
        switch (key) {
          case ('Temperature'):
            return parseTemperatures(current);
          default:
            return current;
        }
      },
    );

    return result;
  }

  dynamic getData({@required bool hourly, @required dynamic source}) {
    dynamic result;
    List<String> filters;
    List<dynamic> dailyForecastsToAdd = [];
    if (hourly) {
      result = List<dynamic>.from([]);
      filters = ['IconPhrase', 'Temperature'];
    } else {
      result = Map<String, dynamic>.from({});
      filters = ['Day', 'Night', 'Temperature'];
    }
    var toParse = hourly ? source : source['DailyForecasts'];
    toParse.asMap().forEach(
          (index, value) => (hourly ? result : dailyForecastsToAdd).add(
                Map.fromIterable(
                    toParse[index].keys.where((key) => filters.contains(key)),
                    value: (key) {
                  final current = toParse[index][key];
                  switch (key) {
                    case ('Temperature'):
                      return hourly
                          ? getTemperature(current['Value'])
                          : parseTemperatures(current);
                    default:
                      return (hourly ? current : current['IconPhrase']);
                  }
                }),
              ),
        );
    if (!hourly) {
      result['DailyForecasts'] = dailyForecastsToAdd;
    }
    return result;
  }

  dynamic parseTemperatures(Map temperaturesMap) {
    Map<String, String> temperatures = Map.fromIterable(temperaturesMap.keys,
        value: (innerKey) =>
            getTemperature(temperaturesMap[innerKey]['Value']));
    return temperatures;
  }

  String getTemperature(num temperature) {
    final strTemp = temperature.toStringAsFixed(1);
    return (temperature > 0 ? '+' : '-') + strTemp;
  }

  @override
  String toString() {
    return 'current:$currentConditions \n hourly:$hourlyForecasts \n daily:$next5DaysForecasts';
  }
}
