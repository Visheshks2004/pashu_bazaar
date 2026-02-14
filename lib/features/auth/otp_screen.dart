import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pashu_bazaar/features/home/home_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String? phoneNumber;

  const OtpScreen({
    super.key, 
    required this.verificationId,
    this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
  bool loading = false;
  String? errorMessage;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final l10n = AppLocalizations.of(context)!;

    if (otpController.text.length != 6) {
      setState(() {
        errorMessage = l10n.enter6DigitOtp;
      });
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
          {
            "uid": user.uid,
            "phone": user.phoneNumber,
            "createdAt": FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = l10n.invalidOtp;
      if (e.code == 'invalid-verification-code') {
        message = l10n.invalidOtpCode;
      } else if (e.code == 'session-expired') {
        message = l10n.otpSessionExpired;
      }
      
      setState(() {
        errorMessage = message;
        loading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.verifyOtpTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ LOCALIZED: Enter OTP sent to phone number
            Text(
              l10n.enterOtpSentTo(widget.phoneNumber ?? l10n.yourNumber),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              l10n.enterOtp,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.enter6DigitOtp,
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 10),
            
            // ✅ LOCALIZED: Didn't receive OTP? Resend
            Row(
              children: [
                Text(l10n.didntReceiveOtp),
                TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: Text(
                    l10n.resend,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        l10n.verify,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}