import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farm_well/screens/education.dart';
import 'package:farm_well/screens/educational_content_detail.dart';
import 'package:farm_well/screens/prediction_detail.dart';
import 'package:farm_well/services/weather.dart';
import 'package:farm_well/screens/all_educational_content_screen.dart';
import 'package:farm_well/screens/weather.dart';
import 'package:farm_well/widgets/prediction_card.dart';
import 'package:farm_well/screens/all_prediction_screen.dart';

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
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
      appBar: AppBar(
        title: const Text("Home"),
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
              const OptionsCard(),
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

class OptionsCard extends StatelessWidget {
  const OptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildIconCard('Identify', Icons.search),
            _buildIconCard('Diagnose', Icons.medical_services),
            _buildIconCard('Book', Icons.book),
            _buildIconCard('Price list', Icons.list),
            _buildIconCard('Guide', Icons.menu_book),
            _buildIconCard('Community', Icons.people),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Predictions',
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
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("predictions")
              .orderBy('timestamp', descending: true)
              .limit(4)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/noData.png",
                        width: 250,
                      ),
                      const SizedBox(height: 16),
                      const Text("No Prediction Results yet"),
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      documents[index].data() as Map<String, dynamic>;
                  String truncatedContent =
                      truncateText(data['result'] ?? '', 20);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PredictionDetail(
                              prediction: data['prediction'] ?? '',
                              cure: data['cure'] ?? '',
                              imagePath: data['image_url'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: PredictionCard(
                        data: data,
                        truncatedContent: truncatedContent,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
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
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              data['image'],
              height: 150,
              fit: BoxFit.cover,
            ),
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
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  truncatedContent,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
