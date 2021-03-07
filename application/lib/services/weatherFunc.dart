import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/WeatherData.dart';

Future<WeatherData> fetchWeather(city_name) async {
  final response = await http.get("https://ilgu-app.herokuapp.com/$city_name");
  //await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
  print(response);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return WeatherData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Unexpected Error');
  }
}
