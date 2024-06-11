import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/educational_content_detail.dart';
import 'package:farm_well/widgets/content_card.dart';

class AllEducationalContentScreen extends StatelessWidget {
  const AllEducationalContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Educational Content"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("educational_content")
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
                        builder: (context) => EducationalContentDetail(
                          title: data['title'],
                          content: data['content'],
                          image: data['image'],
                        ),
                      ),
                    );
                  },
                  child: ContentCard(data: data),
                );
              },
            );
          }
        },
      ),
    );
  }
}
