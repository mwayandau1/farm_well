import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/widgets/content_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:farm_well/screens/educational_content_detail.dart';

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
