import 'package:flutter/material.dart';

class PredictionDetail extends StatelessWidget {
  final String prediction;
  final String imagePath;
  final String cure;

  const PredictionDetail({
    super.key,
    required this.prediction,
    required this.imagePath,
    required this.cure,
  });

  @override
  Widget build(BuildContext context) {
    // Example error handling - use default values or show error messages as needed
    if (prediction.isEmpty || imagePath.isEmpty || cure.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Prediction Detail"),
        ),
        body: const Center(
          child: Text("Error: Missing prediction details"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(imagePath, height: 250, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                prediction,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 75, 74, 74),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                cure,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 20, 20, 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
