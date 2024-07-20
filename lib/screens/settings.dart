import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  final TextEditingController _farmTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _locationController.text = data['location'] ?? '';
            _farmSizeController.text = data['farm_size'] ?? '';
            _farmTypeController.text = data['farm_type'] ?? '';
          });
        }
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_user != null) {
      DocumentReference userDocRef =
          _firestore.collection('users').doc(_user.uid);
      Map<String, dynamic> data = {
        'location': _locationController.text,
        'farm_size': _farmSizeController.text,
        'farm_type': _farmTypeController.text,
      };
      await userDocRef.update(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings updated successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          TextField(
            controller: _farmSizeController,
            decoration: const InputDecoration(labelText: 'Farm Size'),
          ),
          TextField(
            controller: _farmTypeController,
            decoration: const InputDecoration(labelText: 'Farm Type'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateUserData,
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
