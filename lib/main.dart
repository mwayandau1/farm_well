import 'package:farm_well/screens/login.dart';
import 'package:farm_well/widgets/main_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:farm_well/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/widgets/splash_screen.dart';

import 'package:farm_well/screens/community.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyAppWithSplashScreen());
}

class MyAppWithSplashScreen extends StatelessWidget {
  const MyAppWithSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farm Well 😎',
      theme: greenThemeData,
      home: const SplashScreen(),
      routes: {
        // '/identify': (context) => IdentifyScreen(),
        // '/diagnose': (context) => DiagnoseScreen(),
        // '/book': (context) => BookScreen(),
        // '/price-list': (context) => PriceListScreen(),
        // '/guide': (context) => GuideScreen(),
        '/community': (context) => const CommunityScreen(),
      }, // Set the splash screen as the home
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const MainLayout();
        } else {
          return const LogIn();
        }
      },
    );
  }
}
