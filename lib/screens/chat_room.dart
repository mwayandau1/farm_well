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
        title: const Text(
          'Chat Room',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add more actions if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final tweet = Tweet.fromFirestore(message);
                    return buildChatBubble(tweet);
                  },
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: questionController,
              decoration: InputDecoration(
                hintText: 'Message..',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () async {
              if (questionController.text.isNotEmpty && userData != null) {
                await messagesCollection.add({
                  'question': questionController.text,
                  'author': userData!['username'] ?? 'Anonymous',
                  'timestamp': FieldValue.serverTimestamp(),
                }).catchError((error) {
                  print("Failed to add question: $error");
                });
                questionController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildChatBubble(Tweet tweet) {
    final bool isCurrentUser = tweet.author == (userData?['username'] ?? '');
    final bubbleColor =
        isCurrentUser ? Colors.blue.shade100 : Colors.grey.shade200;
    final textColor = isCurrentUser ? Colors.blue.shade800 : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tweet.question,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat.yMMMd().add_jm().format(tweet.timestamp.toDate()),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tweet {
  final String question;
  final String author;
  final Timestamp timestamp;

  Tweet({
    required this.question,
    required this.author,
    required this.timestamp,
  });

  factory Tweet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Tweet(
      question: data['question'] ?? '',
      author: data['author'] ?? 'Anonymous',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
