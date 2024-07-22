import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'About Our Application',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildSection(
                'Welcome to our Plant Disease Prediction and Cure App!',
                'Our mobile application is designed to help farmers and plant enthusiasts predict and cure plant diseases efficiently. Here\'s what our app offers:',
              ),
              _buildFeature(
                'Plant Disease Prediction and Cure',
                'Using advanced AI and machine learning algorithms, our app can predict plant diseases from images and provide suitable cures. Simply take a photo of the affected plant, and our app will do the rest!',
                Icons.local_hospital,
              ),
              _buildFeature(
                'Educational Content',
                'We provide a wealth of educational content for farmers to learn more about various plant diseases, their symptoms, and preventive measures. Stay informed and keep your plants healthy!',
                Icons.school,
              ),
              _buildFeature(
                'Community Interaction',
                'Connect with other users through our in-app chat platform. Share experiences, ask questions, and learn from the community. Our app brings farmers together to create a collaborative environment.',
                Icons.people,
              ),
              _buildFeature(
                'Weather Information',
                'Get real-time weather information to make informed decisions about your farming activities. Stay updated with accurate weather forecasts to protect your plants from adverse weather conditions.',
                Icons.wb_sunny,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                color: Colors.green.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Thank you for choosing our app! We are dedicated to helping you achieve healthier plants and better yields. Happy farming!',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  static Widget _buildFeature(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
