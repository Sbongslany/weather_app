class WeatherData {
  final double temp;
  final double minTemp;
  final double maxTemp;
  final String iconUrl;

  WeatherData({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.iconUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: json['main']['temp'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
      iconUrl: 'https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png',
    );
  }
}
