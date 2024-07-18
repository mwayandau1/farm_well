import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this import
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io'; // Add this import

class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({super.key});

  @override
  State<ProfileScreen1> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Add this line

  User? _user;
  String? _email;
  String? _location;
  String? _farmSize;
  String? _farmType;
  final bool _alertsUpdates = false;
  final bool _marketing = false;
  final bool _content = false;
  final bool _productUpdates = false;
  String? _profilePicture;
  String? _username;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_user!.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            setState(() {
              _email = _user!.email;
              _location = data['location'] ?? 'No location set';
              _farmSize = data['farm_size'] ?? '';
              _farmType = data['farm_type'] ?? '';
              _profilePicture = data['profile_picture'] ?? '';
              _username = data['username'] ?? 'No username set';
            });
          }
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> data) async {
    // ... (keep the existing _updateUserData method)
  }

  Future<void> _changeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      try {
        // Upload image to Firebase Storage
        String fileName = 'profile_pictures/${_user!.uid}.jpg';
        UploadTask uploadTask = _storage.ref().child(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update user profile in Firestore
        await _updateUserData({'profile_picture': downloadUrl});

        // Update local state
        setState(() {
          _profilePicture = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile picture updated successfully.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile picture.')),
        );
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: _changeProfilePicture,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _profilePicture != null && _profilePicture!.isNotEmpty
                              ? NetworkImage(_profilePicture!)
                              : const AssetImage('images/default_avatar.png')
                                  as ImageProvider,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _username ?? 'Username',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _location ?? 'Location',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Add the following ListTile widgets here
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Account screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to History screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Saved screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Help Center screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to About screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogIn()),
              );
            },
          ),
        ],
      ),
    );
  }
}
