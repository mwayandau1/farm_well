import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherService {
  final String apiKey = '25a3d5615f2e3b3de2c5ccdebeb08806';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$apiUrl/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchForecast(String city) async {
    final response = await http
        .get(Uri.parse('$apiUrl/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      List<Map<String, dynamic>> forecast = [];

      for (int i = 0; i < list.length; i += 8) {
        forecast.add({
          'day': DateTime.parse(list[i]['dt_txt']).weekday.toString(),
          'temperature': list[i]['main']['temp'].toString(),
          'icon': list[i]['weather'][0]['main'] == 'Rain'
              ? Icons.cloud
              : Icons.wb_sunny, // Adjust based on actual icon logic
        });
      }

      return forecast;
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
