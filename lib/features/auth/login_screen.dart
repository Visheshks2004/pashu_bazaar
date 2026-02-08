import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pashu_bazaar/features/auth/otp_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            Text(
              l10n.enterPhone,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.2, end: 0),

            const SizedBox(height: 8),

            Text(
              l10n.otpInfo,
              style: const TextStyle(color: Colors.grey),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 30),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("+91", style: TextStyle(fontSize: 16)),
                ),
                hintText: l10n.enterPhoneHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .slideY(begin: 0.2, end: 0),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final phone = "+91${phoneController.text.trim()}";

                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phone,
                    verificationCompleted: (credential) {},
                    verificationFailed: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? "Error")),
                      );
                    },
                    codeSent: (verificationId, _) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OtpScreen(verificationId: verificationId),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (_) {},
                  );
                },
                child: Text(l10n.continueText),
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms)
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
          ],
        ),
      ),
    );
  }
}
