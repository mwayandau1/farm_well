import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_well/widgets/prediction_card_bookmark.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<QueryDocumentSnapshot>>? _bookmarksStream;

  @override
  void initState() {
    super.initState();
    _initializeBookmarksStream();
  }

  void _initializeBookmarksStream() {
    final user = _auth.currentUser;
    if (user != null) {
      _bookmarksStream = _firestore
          .collection('bookmarks')
          .doc(user.uid)
          .collection('predictions')
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }
  }

  Future<void> _toggleBookmark(String docId, Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user != null) {
      final bookmarkRef = _firestore
          .collection('bookmarks')
          .doc(user.uid)
          .collection('predictions')
          .doc(docId);

      final doc = await bookmarkRef.get();
      if (doc.exists) {
        await bookmarkRef.delete();
      } else {
        await bookmarkRef.set(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

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

    if (_bookmarksStream == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: const Center(
          child: Text('Error initializing bookmarks stream.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _bookmarksStream,
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No bookmarks found'),
            );
          }

          final bookmarks = snapshot.data!;

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              final data = bookmark.data() as Map<String, dynamic>;

              return PredictionCard(
                data: data,
                truncatedContent:
                    data['prediction'] ?? 'No prediction available',
                isBookmarked: true, // Define this for the PredictionCard
                onBookmarkToggle: () => _toggleBookmark(
                    bookmark.id, data), // Define this for the PredictionCard
              );
            },
          );
        },
      ),
    );
  }
}
