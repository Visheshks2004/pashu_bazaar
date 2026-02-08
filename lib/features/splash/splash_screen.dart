import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pashu_bazaar/features/home/home_screen.dart';
import 'package:pashu_bazaar/features/language/language_screen.dart';
import 'package:pashu_bazaar/features/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final Function(Locale)? changeLocale;
  
  const SplashScreen({super.key, this.changeLocale});

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
      print('Splash: Initializing app...');
      
      // Check if language is selected
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language');
      
      print('Splash: Language code = $languageCode');
      
      // Small delay for splash
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) {
        print('Splash: Not mounted, returning');
        return;
      }
      
      final user = FirebaseAuth.instance.currentUser;
      print('Splash: Current user = $user');
      
      if (languageCode == null) {
        print('Splash: No language selected, navigating to LanguageScreen');
        _navigateToLanguageScreen();
      } else if (user == null) {
        print('Splash: Language selected but no user, navigating to LoginScreen');
        _navigateToLoginScreen();
      } else {
        print('Splash: Language selected and user logged in, navigating to HomeScreen');
        _navigateToHomeScreen();
      }
    } catch (e) {
      print('Splash Error: $e');
      if (mounted) {
        _navigateToLanguageScreen();
      }
    }
  }

  void _navigateToLanguageScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LanguageScreen(
          onLanguageSelected: (languageCode) {
            if (widget.changeLocale != null) {
              widget.changeLocale!(Locale(languageCode));
            }
          },
        ),
      ),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
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
            // App Icon/Logo
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
            
            // Loading
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