import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather forecast"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherHeader(),
            SizedBox(height: 20),
            WeatherDetail(),
            SizedBox(height: 20),
            NextFourDaysForecast(),
            SizedBox(height: 20),
            ProTip(),
          ],
        ),
      ),
    );
  }
}

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kumasi, 6 Jun',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              '30°C',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Column(
              children: [
                Icon(Icons.cloud, size: 48),
                Text('31°C / 22°C'),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Sunset 18:20',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'It is cloudy today.',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Today would be a bad day for:',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Column(
              children: [
                Icon(Icons.water_drop, size: 24),
                Text('100%'),
              ],
            ),
          ],
        ),
        Text(
          'APPLYING PESTICIDES.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class NextFourDaysForecast extends StatelessWidget {
  const NextFourDaysForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next 4 days',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ForecastDay(day: 'Fri', temperature: '30°C', icon: Icons.cloud),
            ForecastDay(day: 'Sat', temperature: '31°C', icon: Icons.foggy),
            ForecastDay(day: 'Sun', temperature: '31°C', icon: Icons.foggy),
            ForecastDay(day: 'Mon', temperature: '33°C', icon: Icons.cloud),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Rain is forecast for tomorrow.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class ForecastDay extends StatelessWidget {
  final String day;
  final String temperature;
  final IconData icon;

  const ForecastDay(
      {super.key,
      required this.day,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day, style: const TextStyle(fontSize: 16)),
        Icon(icon, size: 32),
        Text(temperature, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class ProTip extends StatelessWidget {
  const ProTip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pro-tip',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'FRIDAY would be a bad day for:',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'APPLYING PESTICIDES.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
