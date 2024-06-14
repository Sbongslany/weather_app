import 'package:intl/intl.dart';

class ForecastData {
  final List<Forecast> forecasts;

  ForecastData({required this.forecasts});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    List<Forecast> forecastList = list.map((i) => Forecast.fromJson(i)).toList();

    return ForecastData(forecasts: forecastList);
  }

  List<DailyForecast> getDailyForecasts() {
    Map<String, List<Forecast>> groupedByDay = {};

    for (var forecast in forecasts) {
      String day = DateFormat('EEE').format(forecast.dateTime);
      if (groupedByDay.containsKey(day)) {
        groupedByDay[day]!.add(forecast);
      } else {
        groupedByDay[day] = [forecast];
      }
    }

    List<DailyForecast> dailyForecasts = [];
    groupedByDay.forEach((day, forecasts) {
      double averageTemp = forecasts.map((f) => f.temperature).reduce((a, b) => a + b) / forecasts.length;
      String iconUrl = forecasts.first.iconUrl;
      dailyForecasts.add(DailyForecast(day: day, temperature: averageTemp, iconUrl: iconUrl));
    });

    return dailyForecasts;
  }
}

class DailyForecast {
  final String day;
  final double temperature;
  final String iconUrl;

  DailyForecast({required this.day, required this.temperature, required this.iconUrl});
}

class Forecast {
  final double temperature;
  final String description;
  final DateTime dateTime;
  final String iconUrl;

  Forecast({
    required this.temperature,
    required this.description,
    required this.dateTime,
    required this.iconUrl,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      dateTime: DateTime.parse(json['dt_txt']),
      iconUrl: 'https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png',
    );
  }
}
