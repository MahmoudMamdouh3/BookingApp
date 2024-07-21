import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getLocationTemperature(String location) async {
  const apiKey = 'd0c084b22e1b4395b6a151502230803';
  final apiUrl =
      'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=no';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final currentData = data['current'];
    final tempC = currentData['temp_c'];
    return tempC;
  } else {
    throw Exception('Failed to load weather data');
  }
}
