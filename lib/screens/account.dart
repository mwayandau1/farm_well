import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  String? _email;
  String? _username;
  String? _phone;
  String? _farmType;

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
            _email = _user.email;
            _username = data['username'] ?? 'No username set';
            _phone = data['phone'] ?? 'No phone set';
            _farmType = data['farm_type'] ?? 'No farm type set';
          });
        }
      }
    }
  }

  void _showAccountDetailsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Email: $_email', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Username: $_username',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Phone: $_phone', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Farm Type: $_farmType',
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showAccountDetailsModal(context),
          child: const Text('Show Account Details'),
        ),
      ),
    );
  }
}
