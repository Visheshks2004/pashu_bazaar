import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pashu_bazaar/features/auth/login_screen.dart';
import 'package:pashu_bazaar/features/home/home_screen.dart';
import 'package:pashu_bazaar/features/language/language_screen.dart';
import 'package:pashu_bazaar/features/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {

  bool loading = true;
  bool languageSelected = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    languageSelected = prefs.getBool("languageSelected") ?? false;

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const SplashScreen();
    }

    if (!languageSelected) {
      return const LanguageScreen();
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
