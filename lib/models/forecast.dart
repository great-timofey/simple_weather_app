import 'package:meta/meta.dart';

class Forecast {
  List<dynamic> hourlyForecasts = List();
  Map<String, dynamic> currentConditions = Map();
  Map<String, dynamic> next5DaysForecasts = Map();

  Map<String, dynamic> get currentForecast => currentConditions;
  List<dynamic> get gethourlyForecastsForNext12Hours => hourlyForecasts;
  Map<String, dynamic> get getforecastsForNext5Days => next5DaysForecasts;

  Forecast.fromJson(
    Map<String, dynamic> rawCurrent,
    List<dynamic> rawNext12Hours,
    Map<String, dynamic> rawNext5Days,
  ) {
    this.currentConditions = getCurrentData(
        source: rawCurrent, filters: ['WeatherText', 'Temperature']);
    this.hourlyForecasts = getHourlyData(rawNext12Hours);
    this.next5DaysForecasts = getDailyData(rawNext5Days);
  }

  Map<String, dynamic> getCurrentData({
    @required Map<String, dynamic> source,
    @required List<String> filters,
  }) {
    Map<String, dynamic> result;
    result = Map.fromIterable(
      source.keys.where((key) => filters.contains(key)),
      value: (key) => source[key],
    );

    return result;
  }

  List<dynamic> getHourlyData(
    List<dynamic> source,
  ) {
    List<dynamic> result = [];
    List<String> filters = ['IconPhrase', 'Temperature'];
    source.asMap().forEach((index, value) => result.add(Map.fromIterable(
          source[index].keys.where((key) => filters.contains(key)),
          value: (key) => source[index][key],
        )));

    return result;
  }

  Map<String, dynamic> getDailyData(
    Map<String, dynamic> source,
  ) {
    Map<String, dynamic> result = {};
    result['Overview'] = source['Headline']['Text'];
    List<dynamic> dailyForecastsToAdd = [];
    List<String> filters = ['Day', 'Night', 'Temperature'];
    source['DailyForecasts']
        .asMap()
        .forEach((index, value) => dailyForecastsToAdd.add(Map.fromIterable(
              source['DailyForecasts'][index]
                  .keys
                  .where((key) => filters.contains(key)),
              value: (key) {
                final current = source['DailyForecasts'][index][key];
                switch (key) {
                  case ('Temperature'):
                    Map<String, String> temperatures = {};
                    temperatures = Map.fromIterable(current.keys,
                        value: (innerKey) =>
                            getTemperature(current[innerKey]['Value']));
                    return temperatures;
                  default:
                    return current['IconPhrase'];
                }
              },
            )));
    result['DailyForecasts'] = dailyForecastsToAdd;

    return result;
  }

  String getTemperature(num temperature) {
    final strTemp = temperature.toStringAsFixed(1);
    return (temperature > 0 ? '+' : '-') + strTemp;
  }

  @override
  String toString() {
    return 'current - $currentConditions \n hourly - $hourlyForecasts \n daily = $next5DaysForecasts';
  }
}
