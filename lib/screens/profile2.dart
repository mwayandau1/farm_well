import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _alertsUpdates = false;
  bool _marketing = false;
  bool _content = false;
  bool _productUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {},
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
            leading: const Icon(Icons.person),
            title: const Text('Profile photo'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle profile photo tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email address'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle email address tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle location tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.aspect_ratio),
            title: const Text('Farm size'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle farm size tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Farm type'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle farm type tap
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
              onPressed: () {
                // Handle sign out
              },
              child: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}
