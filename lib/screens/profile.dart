import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farm_well/screens/account.dart';
import 'package:farm_well/screens/settings.dart';
import 'package:farm_well/screens/bookmarks.dart';
import 'package:farm_well/screens/help_center.dart';
import 'package:farm_well/screens/about.dart';
import 'dart:io';

class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({super.key});

  @override
  State<ProfileScreen1> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;
  String? _email;
  String? _location;
  String? _farmSize;
  String? _farmType;
  String? _profilePicture;
  String? _username;
  bool _isLoading = true;

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
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        print('Error loading user data: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      try {
        String fileName = 'profile_pictures/${_user!.uid}.jpg';
        UploadTask uploadTask = _storage.ref().child(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await _firestore
            .collection('users')
            .doc(_user!.uid)
            .update({'profile_picture': downloadUrl});

        setState(() {
          _profilePicture = downloadUrl;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile picture.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(_username ?? 'Username',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        )),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: _changeProfilePicture,
                          child: Image(
                            image: _profilePicture != null &&
                                    _profilePicture!.isNotEmpty
                                ? NetworkImage(_profilePicture!)
                                : const AssetImage('images/profile_image.jpeg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _location ?? 'Location',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        _buildProfileOption(
                          icon: Icons.account_circle,
                          title: 'Account',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AccountScreen())),
                        ),
                        _buildProfileOption(
                          icon: Icons.bookmark,
                          title: 'Bookmarks',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BookmarksScreen())),
                        ),
                        _buildProfileOption(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingsScreen())),
                        ),
                        _buildProfileOption(
                          icon: Icons.help,
                          title: 'Help Center',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HelpCenterScreen())),
                        ),
                        _buildProfileOption(
                          icon: Icons.info,
                          title: 'About',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AboutScreen())),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
