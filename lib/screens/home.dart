import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farm_well/screens/education.dart';
import 'package:farm_well/screens/educational_content_detail.dart';
import 'package:farm_well/screens/prediction_detail.dart';
import 'package:farm_well/services/weather.dart';
import 'package:farm_well/screens/all_educational_content_screen.dart';
import 'package:farm_well/screens/all_prediction_screen.dart';
import 'package:farm_well/screens/weather.dart';

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
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchCurrentWeather();
    _fetchUserRole();
  }

  Future<void> _fetchCurrentWeather() async {
    try {
      final weatherData = await weatherService.fetchWeather(
          'Kumasi'); // You can make the location dynamic if needed
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
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              ),
            ),
            const SizedBox(height: 16),
            const EducationalContentSection(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  child: const Text('View All'),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Prediction Results',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllPredictionsScreen(),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const PredictionResultsSection(),
          ],
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

class WeatherInfo extends StatelessWidget {
  final String description;
  final double temperature;
  final IconData weatherIcon;

  const WeatherInfo({
    super.key,
    required this.description,
    required this.temperature,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Weather',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
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
        ],
      ),
    );
  }
}

class EducationalContentSection extends StatelessWidget {
  const EducationalContentSection({super.key});

  String truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    return '${words.take(maxWords).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("educational_content")
          .orderBy('timestamp', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Image.asset(
                    "images/noData.png",
                    width: 250,
                  ),
                  const Text("No Educational Content yet"),
                ],
              ),
            );
          }
          return CarouselSlider(
            items: documents.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String truncatedContent =
                  truncateText(data['content'], 30); // Limiting to 30 words

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationalContentDetail(
                        title: data['title'],
                        content: data['content'],
                        image: data['image'],
                      ),
                    ),
                  );
                },
                child: ContentCard(
                  data: data,
                  truncatedContent: truncatedContent,
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 300,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
        }
      },
    );
  }
}

class PredictionResultsSection extends StatelessWidget {
  const PredictionResultsSection({super.key});

  String truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    return '${words.take(maxWords).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("predictions")
          .orderBy('timestamp', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              children: [
                Image.asset(
                  "images/noData.png",
                  width: 250,
                ),
                const Text("No Prediction Results yet"),
              ],
            ),
          );
        } else {
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: documents.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                String truncatedPrediction = truncateText(
                    data['prediction'], 20); // Limiting to 20 words
                String truncatedCure =
                    truncateText(data['cure'], 30); // Limiting to 30 words

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PredictionDetail(
                          prediction: data['prediction'],
                          cure: data['cure'], // Ensure this line is included
                          imagePath: data['image_url'],
                        ),
                      ),
                    );
                  },
                  child: PredictionCard(
                    data: data,
                    truncatedPrediction: truncatedPrediction,
                    truncatedCure: truncatedCure,
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

class ContentCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String truncatedContent;

  const ContentCard({
    super.key,
    required this.data,
    required this.truncatedContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              data['image'],
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    truncatedContent,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String truncatedPrediction;
  final String truncatedCure;

  const PredictionCard({
    super.key,
    required this.data,
    required this.truncatedPrediction,
    required this.truncatedCure,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              data['image_url'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              truncatedPrediction,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              truncatedCure,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
