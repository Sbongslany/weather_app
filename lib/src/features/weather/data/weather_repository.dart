import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_it/get_it.dart';

import '../models/forecast_data.dart';
import '../models/weather_data.dart';

class HttpWeatherRepository {
  final OpenWeatherMapAPI api;
  final http.Client client;

  HttpWeatherRepository({
    required this.api,
    required this.client,
  });

  factory HttpWeatherRepository.create() {
    return HttpWeatherRepository(
      api: OpenWeatherMapAPI(GetIt.instance<String>(instanceName: 'api_key')),
      client: http.Client(),
    );
  }

  Future<WeatherData> getWeather({required String city}) async {
    final response = await client.get(api.weather(city));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return WeatherData.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<ForecastData> getForecast({required String city}) async {
    final response = await client.get(api.forecast(city));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return ForecastData.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
