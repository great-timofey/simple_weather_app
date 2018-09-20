class Forecast {
  List<String> now = [];
  List<String> hourly = [];
  List<String> daily = [];

  String get currentTemp => now[0];
  String get currentForecast => now[1];
  String get hourlyTemp => hourly[0];
  String get hourlyForecast => hourly[1];
  String get dailyMinTemp => daily[0];
  String get dailyMaxTemp => daily[1];

  Forecast(this.now, this.hourly, this.daily);
  Forecast.fromJson(Map<String, dynamic> rawForecast) {
    this.now = List.from(now)
      ..add(getTemperature(rawForecast['currently']['temperature']))
      ..add(rawForecast['currently']['summary']);
    this.hourly = List.from(hourly)
      ..add(getTemperature(rawForecast['hourly']['data'][0]['temperature']))
      ..add(rawForecast['hourly']['data'][0]['summary']);
    this.daily = List.from(daily)
      ..add(getTemperature(rawForecast['daily']['data'][0]['temperatureLow']))
      ..add(getTemperature(rawForecast['daily']['data'][0]['temperatureHigh']));
  }

  String getTemperature(num temperature) {
    final strTemp = temperature.toStringAsFixed(1);
    return (temperature > 0 ? '+' : '-') + strTemp;
  }

  @override
  String toString() {
    return '$now - $hourly - $daily';
  }
}
