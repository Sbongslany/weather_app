import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;

import '../models/forecast_data.dart';
import '../models/weather_data.dart';

class WeatherProvider extends ChangeNotifier {
  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
  );

  String city = 'London';
  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getWeatherData() async {
    isLoading = true;
    errorMessage = null;
    currentWeatherProvider=null;
    hourlyWeatherProvider=null;
    notifyListeners();

    try {
      final weather = await repository.getWeather(city: city);
      currentWeatherProvider = weather;
      await getForecastData();
    } catch (e) {
      errorMessage = 'Failed to load weather data';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getForecastData() async {
    try {
      final forecast = await repository.getForecast(city: city);
      hourlyWeatherProvider = forecast;
    } catch (e) {
      errorMessage = 'Failed to load forecast data';
    }
    notifyListeners();
  }
}
