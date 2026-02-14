import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pashu_bazaar/features/auth/login_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';
import 'package:pashu_bazaar/main.dart'; // Import to access MyApp

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';
  String _selectedLanguageCode = 'en';

  final Map<String, String> _languages = {
    'English': 'en',
    'हिंदी (Hindi)': 'hi',
    'मराठी (Marathi)': 'mr',
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('language');
    
    if (savedLanguageCode != null) {
      final entry = _languages.entries.firstWhere(
        (entry) => entry.value == savedLanguageCode,
        orElse: () => _languages.entries.first,
      );
      
      if (mounted) {
        setState(() {
          _selectedLanguage = entry.key;
          _selectedLanguageCode = entry.value;
        });
      }
    }
  }

  Future<void> _saveAndContinue() async {
    try {
      // ✅ CHANGE LANGUAGE GLOBALLY
      await MyApp.of(context)?.changeLanguage(_selectedLanguageCode);
      
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error saving language: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                l10n != null ? 'Welcome to' : 'Welcome to',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 5),
              const Text(
                'Pashu Bazaar',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n != null ? 'Select your preferred language' : 'Select your preferred language',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              
              const SizedBox(height: 40),
              
              Expanded(
                child: ListView(
                  children: _languages.keys.map((languageName) {
                    final languageCode = _languages[languageName]!;
                    return _buildLanguageTile(languageName, languageCode);
                  }).toList(),
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    l10n != null ? l10n.continueText : 'Continue',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String languageName, String languageCode) {
    final isSelected = _selectedLanguageCode == languageCode;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: isSelected ? 2 : 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.language,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          languageName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.green : Colors.black,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          setState(() {
            _selectedLanguage = languageName;
            _selectedLanguageCode = languageCode;
          });
        },
      ),
    );
  }
}