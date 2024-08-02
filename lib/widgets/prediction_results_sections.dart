import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/all_prediction_screen.dart';
import 'package:farm_well/screens/prediction_detail.dart';
import 'package:farm_well/widgets/prediction_card.dart';
import 'package:flutter/material.dart';

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
                  String predictionId =
                      documents[index].id; // Get the document ID

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PredictionDetail(
                              predictionId:
                                  predictionId, // Pass the document ID
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
