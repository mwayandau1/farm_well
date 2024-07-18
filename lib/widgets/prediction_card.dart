import 'package:flutter/material.dart';

class PredictionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String truncatedContent;

  const PredictionCard({
    super.key,
    required this.data,
    required this.truncatedContent,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        data['image_url'] ?? 'https://example.com/default_image.jpg';
    String predictionText = data['prediction'] ?? 'No prediction available';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
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
        color: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              predictionText,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
