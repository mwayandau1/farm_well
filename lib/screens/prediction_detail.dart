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
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                cure,
                style: const TextStyle(fontSize: 16.0, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
