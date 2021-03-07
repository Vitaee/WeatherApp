class WeatherData {
  final String feel;
  final String temp;
  final String humidity;
  final String state;
  final String wind;
  final String cityName;

  WeatherData(
      {this.feel,
      this.temp,
      this.humidity,
      this.state,
      this.wind,
      this.cityName});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    print(json);
    return WeatherData(
        feel: json['WeatherFeel'],
        temp: json['WeatherTemp'],
        humidity: json['WeatherHumidity'],
        state: json['WeatherState'],
        wind: json['WeatherWind'],
        cityName: json['WeatherCity']);
  }
}
