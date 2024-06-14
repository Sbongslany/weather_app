import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: SafeArea(
          child: Consumer<WeatherProvider>(
            builder: (_,__,____) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CitySearchBox(),
                  SizedBox(
                    height: 20,
                  ),
                  CurrentWeather(),
                  SizedBox(
                    height: 40,
                  ),
                  if (context
                      .read<WeatherProvider>()
                      .hourlyWeatherProvider
                      ?.getDailyForecasts()
                      .isNotEmpty ?? false)
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, pos) {
                              var forecasts = context
                                  .read<WeatherProvider>()
                                  .hourlyWeatherProvider
                                  ?.getDailyForecasts();
                              return ForecastWeatherContents(
                                data: forecasts![pos],
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: context
                                .read<WeatherProvider>()
                                .hourlyWeatherProvider
                                ?.getDailyForecasts()
                                .length,
                          ),
                        )),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
