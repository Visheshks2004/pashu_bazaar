// If you have app_start_screen.dart, update it:
import 'package:flutter/material.dart';
import 'package:pashu_bazaar/features/language/language_screen.dart';

class AppStartScreen extends StatelessWidget {
  const AppStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is now redundant since SplashScreen handles everything
    // But if you need to keep it, redirect to LanguageScreen
    return const LanguageScreen();
  }
}