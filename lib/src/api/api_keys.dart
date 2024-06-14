import 'package:get_it/get_it.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

/// To get an API key, sign up here:
/// https://home.openweathermap.org/users/sign_up
///

final sl = GetIt.instance;

void setupInjection() {
  // Register the API key with the instance name 'api_key'
  sl.registerSingleton<String>('5b9a8781d84279ed36cd907cbbef0ab7', instanceName: 'api_key');
  // Register other dependencies if needed
  // For example:
  // Register HttpWeatherRepository as a singleton
  sl.registerSingleton<HttpWeatherRepository>(
    HttpWeatherRepository(
      api: OpenWeatherMapAPI(sl.get<String>(instanceName: 'api_key')),
      client: http.Client(),
    ),
  );
}
