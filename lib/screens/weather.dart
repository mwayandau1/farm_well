import 'package:flutter/material.dart';
import 'package:farm_well/services/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  late Future<Map<String, dynamic>> weatherData;
  late Future<List<Map<String, dynamic>>> forecastData;
  final WeatherService weatherService = WeatherService();
  String _city = 'Kumasi';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() {
    setState(() {
      weatherData = weatherService.fetchWeather(_city);
      forecastData = weatherService.fetchForecast(_city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  _city = value;
                  _fetchWeatherData();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: weatherData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error fetching weather data'));
                  } else {
                    final weather = snapshot.data!;
                    return ListView(
                      children: [
                        WeatherHeader(weather: weather),
                        const SizedBox(height: 20),
                        WeatherDetail(weather: weather),
                        const SizedBox(height: 20),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: forecastData,
                          builder: (context, forecastSnapshot) {
                            if (forecastSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (forecastSnapshot.hasError) {
                              return const Center(
                                  child: Text('Error fetching forecast data'));
                            } else {
                              final forecast = forecastSnapshot.data!;
                              return NextFourDaysForecast(
                                  forecastData: forecast);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        // const ProTip(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherHeader extends StatelessWidget {
  final Map<String, dynamic> weather;

  const WeatherHeader({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${weather['name']}, ${DateTime.now().toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '${weather['main']['temp']}°C',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Column(
              children: [
                const Icon(Icons.cloud,
                    size: 48), // Change based on weather condition
                Text(
                    '${weather['main']['temp_max']}°C / ${weather['main']['temp_min']}°C'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Sunset ${DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunset'] * 1000).toLocal().toString().split(' ')[1].substring(0, 5)}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final Map<String, dynamic> weather;

  const WeatherDetail({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weather['weather'][0]['description'],
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Today would be a bad day for:',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Column(
              children: [
                const Icon(Icons.water_drop, size: 24),
                Text('${weather['main']['humidity']}%'),
              ],
            ),
          ],
        ),
        const Text(
          'APPLYING PESTICIDES.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

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
