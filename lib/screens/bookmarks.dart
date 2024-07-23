import 'package:farm_well/widgets/prediction_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: const Center(
          child: Text('Please log in to see your bookmarks.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(user.uid)
            .collection('predictions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching bookmarks'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No bookmarks found'),
            );
          }

          final bookmarks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              final data = bookmark.data() as Map<String, dynamic>;

              return PredictionCard(
                data: data,
                truncatedContent:
                    data['prediction'] ?? 'No prediction available',
              );
            },
          );
        },
      ),
    );
  }
}
