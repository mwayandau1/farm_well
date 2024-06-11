import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/prediction_detail.dart';
import 'package:farm_well/widgets/prediction_card.dart';

class AllPredictionsScreen extends StatelessWidget {
  const AllPredictionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Predictions"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("predictions")
            .orderBy('timestamp', descending: true)
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
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    documents[index].data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PredictionDetail(
                          prediction: data['prediction'],
                          imagePath: data['image_url'],
                        ),
                      ),
                    );
                  },
                  child: PredictionCard(data: data),
                );
              },
            );
          }
        },
      ),
    );
  }
}
