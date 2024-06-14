import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

const encodedWeatherJsonResponse = """
{
  "coord": {
    "lon": -122.08,
    "lat": 37.39
  },
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "visibility": 16093,
  "wind": {
    "speed": 1.5,
    "deg": 350
  },
  "clouds": {
    "all": 1
  },
  "dt": 1560350645,
  "sys": {
    "type": 1,
    "id": 5122,
    "message": 0.0139,
    "country": "US",
    "sunrise": 1560343627,
    "sunset": 1560396563
  },
  "timezone": -25200,
  "id": 420006353,
  "name": "Mountain View",
  "cod": 200
}
""";

final expectedWeatherFromJson = WeatherData(
  temp: 282.55,
  minTemp: 280.37,
  maxTemp: 284.26,
  iconUrl: 'https://openweathermap.org/img/wn/01d@2x.png',
);

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  group('WeatherRepository', () {
    late MockHttpClient mockHttpClient;
    late OpenWeatherMapAPI api;
    late HttpWeatherRepository weatherRepository;

    setUp(() {
      mockHttpClient = MockHttpClient();
      api = OpenWeatherMapAPI('5b9a8781d84279ed36cd907cbbef0ab7');
      weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);
    });

    test('repository with mocked http client, success', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response(encodedWeatherJsonResponse, 200),
      );

      final weather = await weatherRepository.getWeather(city: 'London');

      expect(weather.temp, expectedWeatherFromJson.temp);
      expect(weather.minTemp, expectedWeatherFromJson.minTemp);
      expect(weather.maxTemp, expectedWeatherFromJson.maxTemp);
      expect(weather.iconUrl, expectedWeatherFromJson.iconUrl);
    });

    test('repository with mocked http client, failure', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response('Not Found', 404),
      );

      expect(
            () async => await weatherRepository.getWeather(city: 'Invalid City'),
        throwsException,
      );
    });
  });
}
