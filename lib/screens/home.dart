import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/widgets/educational_content_section.dart';
import 'package:farm_well/widgets/prediction_results_sections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farm_well/screens/education.dart';
import 'package:farm_well/services/weather.dart';
import 'package:farm_well/screens/all_educational_content_screen.dart';
import 'package:farm_well/screens/weather.dart';
import 'package:farm_well/widgets/options_card.dart';
import 'package:farm_well/widgets/weaether_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String description = 'Loading...';
  double temperature = 0.0;
  IconData weatherIcon = Icons.wb_sunny; // Default icon
  final WeatherService weatherService = WeatherService();
  String userRole = '';
  String userName = '';

  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchCurrentWeather();
    _fetchUserRole();
    _fetchUserName();
  }

  Future<void> _fetchCurrentWeather() async {
    try {
      final weatherData = await weatherService.fetchWeather('Kumasi');
      setState(() {
        description = weatherData['weather'][0]['description'];
        temperature = weatherData['main']['temp'];
        weatherIcon = _getWeatherIcon(weatherData['weather'][0]['main']);
      });
    } catch (e) {
      setState(() {
        description = 'Error fetching weather';
      });
    }
  }

  Future<void> _fetchUserRole() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userRole = userDoc['role'];
        });
      }
    }
  }

  Future<void> _fetchUserName() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['username'] ?? 'User';
        });
      }
    }
  }

  IconData _getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'rain':
        return Icons.grain;
      case 'clouds':
        return Icons.cloud;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_sunny; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Farmwell"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top weather section with search bar inside
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WeatherScreen(),
                    ),
                  );
                },
                child: WeatherInfo(
                  description: description,
                  temperature: temperature,
                  weatherIcon: weatherIcon,
                  userName: userName,
                ),
              ),
              const SizedBox(height: 16),
              // Card with various options
              const CropCard(),
              const SizedBox(height: 16),
              // Educational content section
              const Text(
                'Educational Content',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8),
              const EducationalContentSection(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AllEducationalContentScreen(),
                      ),
                    );
                  },
                  child: const Text('See all'),
                ),
              ),

              const PredictionResultsSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EducationalScreen(),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
