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
      setState(() {
        _email = _user!.email;
        _location = userDoc['location'];
        _farmSize = userDoc['farmSize'];
        _farmType = userDoc['farmType'];
        _alertsUpdates = userDoc['alertsUpdates'];
        _marketing = userDoc['marketing'];
        _content = userDoc['content'];
        _productUpdates = userDoc['productUpdates'];
      });
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> data) async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update(data);
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
              _updateUserData({
                'alertsUpdates': _alertsUpdates,
                'marketing': _marketing,
                'content': _content,
                'productUpdates': _productUpdates,
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
              _showEditDialog('Email address', _email ?? '', (value) {
                _user!.updateEmail(value).then((_) {
                  setState(() {
                    _email = value;
                  });
                });
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(_location ?? 'Location'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showEditDialog('Location', _location ?? '', (value) {
                setState(() {
                  _location = value;
                  _updateUserData({'location': value});
                });
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.aspect_ratio),
            title: Text(_farmSize ?? 'Farm size'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showEditDialog('Farm size', _farmSize ?? '', (value) {
                setState(() {
                  _farmSize = value;
                  _updateUserData({'farmSize': value});
                });
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(_farmType ?? 'Farm type'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showEditDialog('Farm type', _farmType ?? '', (value) {
                setState(() {
                  _farmType = value;
                  _updateUserData({'farmType': value});
                });
              });
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

  void _showEditDialog(
      String title, String initialValue, Function(String) onSave) {
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
                onSave(controller.text);
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
