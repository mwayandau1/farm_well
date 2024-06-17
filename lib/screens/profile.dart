import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/screens/login.dart'; // replace with your actual path
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _email;
  String? _location;
  String? _farmSize;
  String? _farmType;
  bool _alertsUpdates = false;
  bool _marketing = false;
  bool _content = false;
  bool _productUpdates = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _email = _user!.email;
            _location = data['location'] ?? '';
            _farmSize = data['farm_size'] ?? '';
            _farmType = data['farm_type'] ?? '';
            _alertsUpdates = data['alerts_updates'] ?? false;
            _marketing = data['marketing'] ?? false;
            _content = data['content'] ?? false;
            _productUpdates = data['product_updates'] ?? false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User data is not available.'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User data not found.'),
        ));
      }
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> data) async {
    if (_user != null) {
      DocumentReference userDocRef =
          _firestore.collection('users').doc(_user!.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      try {
        // If the document exists, update it with the new data
        if (userDoc.exists) {
          await userDocRef.update(data);
        }
        // If the document doesn't exist, create a new document with the data
        else {
          await userDocRef.set(data);
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User data updated successfully.'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update user data.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Update the notification preference fields in Firestore
              _updateUserData({
                'alerts_updates': _alertsUpdates,
                'marketing': _marketing,
                'content': _content,
                'product_updates': _productUpdates,
              });
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(_email ?? 'Email address'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show a dialog to edit the email address
              _showEditDialog('Email address', _email ?? '', 'email');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(_location ?? 'Location'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show a dialog to edit the location
              _showEditDialog('Location', _location ?? '', 'location');
            },
          ),
          ListTile(
            leading: const Icon(Icons.aspect_ratio),
            title: Text(_farmSize ?? 'Farm size'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show a dialog to edit the farm size
              _showEditDialog('Farm size', _farmSize ?? '', 'farm_size');
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(_farmType ?? 'Farm type'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show a dialog to edit the farm type
              _showEditDialog('Farm type', _farmType ?? '', 'farm_type');
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Alerts & Updates'),
            value: _alertsUpdates,
            onChanged: (value) {
              setState(() {
                _alertsUpdates = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Marketing'),
            value: _marketing,
            onChanged: (value) {
              setState(() {
                _marketing = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Content'),
            value: _content,
            onChanged: (value) {
              setState(() {
                _content = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Product updates'),
            value: _productUpdates,
            onChanged: (value) {
              setState(() {
                _productUpdates = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LogIn()),
                );
              },
              child: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String title, String initialValue, String fieldName) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter $title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the corresponding field in Firestore
                _updateUserData({fieldName: controller.text});
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
