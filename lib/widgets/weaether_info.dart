import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  final String description;
  final double temperature;
  final IconData weatherIcon;
  final String userName;

  const WeatherInfo({
    super.key,
    required this.description,
    required this.temperature,
    required this.weatherIcon,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 51, 121, 58),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $userName',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(weatherIcon, color: Colors.white, size: 48.0),
              const SizedBox(width: 16.0),
              Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(
                  fontSize: 48.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // ... rest of the widget
        ],
      ),
    );
  }
}
