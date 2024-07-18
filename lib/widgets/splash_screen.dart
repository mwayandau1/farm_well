import 'package:flutter/material.dart';
import 'package:farm_well/main.dart'; // Import MyApp

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Duration for splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const MyApp()), // Navigate to MyApp
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.green, // Set the background color here
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/splash.jpeg'), // Your splash screen image
              const SizedBox(height: 20),
              const Text(
                'Welcome to Farm Well',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
