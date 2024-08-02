import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/prediction_detail.dart';
import 'package:farm_well/widgets/prediction_card.dart';

class AllPredictionsScreen extends StatefulWidget {
  const AllPredictionsScreen({super.key});

  @override
  _AllPredictionsScreenState createState() => _AllPredictionsScreenState();
}

class _AllPredictionsScreenState extends State<AllPredictionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Predictions"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by prediction',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                  if (_searchText.isNotEmpty) {
                    documents = documents.where((doc) {
                      String prediction =
                          (doc['prediction'] as String).toLowerCase();
                      return prediction.contains(_searchText);
                    }).toList();
                  }
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          documents[index].data() as Map<String, dynamic>;
                      String predictionId =
                          documents[index].id; // Get the document ID

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PredictionDetail(
                                predictionId:
                                    predictionId, // Pass the document ID
                                prediction: data['prediction'],
                                cure: data['cure'],
                                imagePath: data['image_url'],
                              ),
                            ),
                          );
                        },
                        child: PredictionCard(
                          data: data,
                          truncatedContent: '',
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
