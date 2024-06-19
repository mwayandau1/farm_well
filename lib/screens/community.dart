import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final TextEditingController questionController = TextEditingController();
  User? currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (userData != null) buildProfileSection(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: 'Ask a question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (questionController.text.isNotEmpty &&
                        currentUser != null) {
                      await messagesCollection.add({
                        'question': questionController.text,
                        'author': userData!['username'] ?? 'Anonymous',
                        'responses': [],
                        'likes': 0,
                        'timestamp': FieldValue.serverTimestamp(),
                      }).catchError((error) {
                        print("Failed to add question: $error");
                      });
                      questionController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages found.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final tweet = Tweet(
                      question: message['question'],
                      author: message['author'],
                      responses: (message['responses'] as List<dynamic>)
                          .map((response) => Response.fromMap(response))
                          .toList(),
                      likes: message['likes'],
                    );
                    return buildTweetCard(tweet, message.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username: ${userData!['username']}',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Email: ${userData!['email']}',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTweetCard(Tweet tweet, String docId) {
    final commentController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/50'),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweet.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '@${tweet.author.toLowerCase()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            tweet.question,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),
          ...tweet.responses.map((response) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.only(bottom: 8.0),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/50'),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          response.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '@${response.author.toLowerCase()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          response.text,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8.0),
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: 'Write a response',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    final response = Response(
                      text: commentController.text,
                      author: userData!['username'] ?? 'Anonymous',
                    );
                    tweet.responses.add(response);

                    await messagesCollection.doc(docId).update({
                      'responses': FieldValue.arrayUnion([response.toMap()]),
                    }).catchError((error) {
                      print("Failed to add response: $error");
                    });

                    commentController.clear();
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tweet {
  final String question;
  final String author;
  final List<Response> responses;
  int likes;

  Tweet({
    required this.question,
    required this.author,
    required this.responses,
    this.likes = 0,
  });
}

class Response {
  final String text;
  final String author;

  Response({required this.text, required this.author});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'author': author,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      text: map['text'],
      author: map['author'],
    );
  }
}
