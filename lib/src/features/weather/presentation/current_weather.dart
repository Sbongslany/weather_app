import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';

import '../models/weather_data.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider,
        (String city, WeatherData?, bool, String?)>(
      selector: (context, provider) => (
        provider.city,
        provider.currentWeatherProvider,
        provider.isLoading,
        provider.errorMessage
      ),
      builder: (context, data, _) {
        final city = data.$1;
        final weatherData = data.$2;
        final isLoading = data.$3;
        final errorMessage = data.$4;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(city, style: Theme.of(context).textTheme.headlineMedium),
            if (isLoading)
              const CircularProgressIndicator()
            else if (errorMessage != null)
              Text(errorMessage, style: TextStyle(color: Colors.red))
            else if (weatherData == null)
              Text('No weather data available')
            else
              CurrentWeatherContents(data: weatherData),
          ],
        );
      },
    );
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.toInt().toString();
    final minTemp = data.minTemp.toInt().toString();
    final maxTemp = data.maxTemp.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.iconUrl, size: 120),
        Text(temp, style: textTheme.displayMedium),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}

class ForecastWeatherContents extends StatelessWidget {
  const ForecastWeatherContents({super.key, required this.data});

  final DailyForecast data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temperature.toInt();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(data.day, style: textTheme.displayMedium),
        WeatherIconImage(iconUrl: data.iconUrl, size: 120),
        Text("${temp}°", style: textTheme.displayMedium),
      ],
    );
  }
}
