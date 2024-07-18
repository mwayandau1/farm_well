import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/educational_content_detail.dart';
import 'package:farm_well/widgets/content_card1.dart';

class AllEducationalContentScreen extends StatefulWidget {
  const AllEducationalContentScreen({super.key});

  @override
  _AllEducationalContentScreenState createState() =>
      _AllEducationalContentScreenState();
}

class _AllEducationalContentScreenState
    extends State<AllEducationalContentScreen> {
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
        title: const Text("All Educational Content"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by title',
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
                  .collection("educational_content")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  if (_searchText.isNotEmpty) {
                    documents = documents.where((doc) {
                      String title = (doc['title'] as String).toLowerCase();
                      return title.contains(_searchText);
                    }).toList();
                  }
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
          ),
        ],
      ),
    );
  }
}
