import 'package:farm_well/screens/predictions1.dart';
// import 'package:farm_well/screens/profile.dart';
// import 'package:farm_well/screens/home.dart';
import 'package:farm_well/screens/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:farm_well/screens/profile.dart';
import 'package:farm_well/screens/home.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    const PredictionScreen(),
    const CommunityScreen(),
    const ProfileScreen1(),
  ];

  @override
  Widget build(BuildContext context) {
    // Extract the green color from the theme

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Bar'),
      // ),
      backgroundColor: Colors.grey,

      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.online_prediction),
            label: 'Prediction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Chat Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
