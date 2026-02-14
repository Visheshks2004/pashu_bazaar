import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pashu_bazaar/features/home/home_screen.dart';
import 'package:pashu_bazaar/features/language/language_screen.dart';
import 'package:pashu_bazaar/features/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Small delay for splash animation
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // ✅ Check if language is selected FIRST
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language');
      
      print('Splash: Language code = $languageCode'); // Debug log
      
      if (languageCode == null) {
        // No language selected - go to LanguageScreen
        print('Splash: No language selected, going to LanguageScreen');
        _navigateToLanguageScreen();
        return;
      }
      
      // Language is selected, check authentication
      final user = FirebaseAuth.instance.currentUser;
      print('Splash: User = ${user?.phoneNumber}');
      
      if (user == null) {
        // Language selected but not logged in - go to Login
        print('Splash: Not logged in, going to LoginScreen');
        _navigateToLoginScreen();
      } else {
        // Language selected and logged in - go to Home
        print('Splash: Logged in, going to HomeScreen');
        _navigateToHomeScreen();
      }
    } catch (e) {
      print('Splash Error: $e');
      if (mounted) {
        // On error, go to language screen as safe fallback
        _navigateToLanguageScreen();
      }
    }
  }

  void _navigateToLanguageScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LanguageScreen(),
      ),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200, width: 2),
              ),
              child: const Icon(
                Icons.pets,
                size: 60,
                color: Colors.green,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // App Name
            const Text(
              "Pashu Bazaar",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Tagline
            const Text(
              "Buy & Sell Livestock",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.green,
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}