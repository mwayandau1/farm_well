import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionDetail extends StatelessWidget {
  final String predictionId;
  final String prediction;
  final String imagePath;
  final String cure;

  const PredictionDetail({
    super.key,
    required this.predictionId,
    required this.prediction,
    required this.imagePath,
    required this.cure,
  });

  Future<void> _deletePrediction(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('predictions')
          .doc(predictionId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prediction deleted successfully')),
      );

      Navigator.of(context).pop(); // Go back after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete prediction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (prediction.isEmpty || imagePath.isEmpty || cure.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Prediction Detail"),
          backgroundColor: Colors.red,
        ),
        body: const Center(
          child: Text(
            "Error: Missing prediction details",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Detail"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deletePrediction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Failed to load image'));
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prediction:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prediction,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cure:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cure,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
