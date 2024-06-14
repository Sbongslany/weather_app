import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:provider/provider.dart';

// Fake classes
class FakeForecastData extends Fake implements ForecastData {}
class FakeDateTime extends Fake implements DateTime {}

// Mock class for WeatherProvider
class MockWeatherProvider extends Mock implements WeatherProvider {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeForecastData());
    registerFallbackValue(FakeDateTime());
  });

  group('WeatherPage', () {
    testWidgets('should show weather page with data', (WidgetTester tester) async {
      final mockWeatherProvider = MockWeatherProvider();

      when(() => mockWeatherProvider.city).thenReturn('London');
      when(() => mockWeatherProvider.hourlyWeatherProvider).thenReturn(
        ForecastData(forecasts: [
          Forecast(
            temperature: 25.0,
            description: 'Cloudy',
            dateTime: DateTime.now(),
            iconUrl: 'https://openweathermap.org/img/wn/01d@2x.png',
          ),
        ]),
      );
      when(() => mockWeatherProvider.isLoading).thenReturn(false); // Mock isLoading

      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherProvider>.value(
          value: mockWeatherProvider,
          child: const MaterialApp(
            home: WeatherPage(city: 'London'),
          ),
        ),
      );


      expect(find.byType(CitySearchBox), findsOneWidget);


      expect(find.byType(CurrentWeather), findsOneWidget);


      expect(find.byType(ForecastWeatherContents), findsNWidgets(
        mockWeatherProvider.hourlyWeatherProvider!.forecasts.length,
      ));


    });
  });
}
