import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
        title: const Text('Community',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: questionController,
              decoration: InputDecoration(
                hintText: 'Ask a question...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () async {
                    if (questionController.text.isNotEmpty &&
                        userData != null) {
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
                      timestamp: message['timestamp'] as Timestamp,
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

  Widget buildTweetCard(Tweet tweet, String docId) {
    final commentController = TextEditingController();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://api.adorable.io/avatars/50/${tweet.author}.png'),
                ),
                const SizedBox(width: 12.0),
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
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(tweet.timestamp.toDate()),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              tweet.question,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite,
                      color: tweet.likes > 0 ? Colors.red : Colors.grey),
                  onPressed: () {
                    // Implement like functionality
                  },
                ),
                Text('${tweet.likes}'),
                const SizedBox(width: 16.0),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.blue),
                  onPressed: () {
                    // Implement comment functionality
                  },
                ),
                Text('${tweet.responses.length}'),
              ],
            ),
            const Divider(),
            ...tweet.responses.map((response) => buildResponseWidget(response)),
            const SizedBox(height: 8.0),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Write a response...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () async {
                    if (commentController.text.isNotEmpty && userData != null) {
                      final response = Response(
                        text: commentController.text,
                        author: userData!['username'] ?? 'Anonymous',
                        timestamp: Timestamp.now(),
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
      ),
    );
  }

  Widget buildResponseWidget(Response response) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://api.adorable.io/avatars/40/${response.author}.png'),
            radius: 16,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      response.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      DateFormat.jm().format(response.timestamp.toDate()),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  response.text,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                ),
              ],
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
  final Timestamp timestamp;

  Tweet({
    required this.question,
    required this.author,
    required this.responses,
    this.likes = 0,
    required this.timestamp,
  });
}

class Response {
  final String text;
  final String author;
  final Timestamp timestamp;

  Response({required this.text, required this.author, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'author': author,
      'timestamp': timestamp,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      text: map['text'],
      author: map['author'],
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
