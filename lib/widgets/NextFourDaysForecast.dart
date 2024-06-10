import 'package:flutter/material.dart';

class NextFourDaysForecast extends StatelessWidget {
  final List<Map<String, dynamic>> forecastData;

  const NextFourDaysForecast({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next 4 days',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: forecastData.map((day) {
            return ForecastDay(
              day: day['day'],
              temperature: '${day['temperature']}°C',
              icon: day['icon'],
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        const Text(
          'Rain is forecast for tomorrow.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
