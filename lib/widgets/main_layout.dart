import 'package:flutter/material.dart';
import 'package:farm_well/screens/predictions.dart';
import 'package:farm_well/screens/profile.dart';
import 'package:farm_well/screens/home.dart';
import 'package:farm_well/screens/chat_room.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
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
