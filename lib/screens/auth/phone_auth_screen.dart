import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;
  String _verificationId = '';

  // ── Step 1: Send OTP ─────────────────────────────────────
  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()));
        },
        verificationFailed: (FirebaseAuthException e) {
          _showError(e.message ?? 'Verification failed');
          setState(() => _isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
          _showSuccess('OTP sent to ${_phoneController.text}');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _showError(e.toString());
      setState(() => _isLoading = false);
    }
  }

  // ── Step 2: Verify OTP ───────────────────────────────────
  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      _showError('Please enter the OTP');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      _showError('Invalid OTP. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  void _showSuccess(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.primary));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Enter your phone number',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              _otpSent
                  ? 'Enter the OTP sent to ${_phoneController.text}'
                  : 'We will send you a verification code',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // ── Phone field ──────────────────────────────
            if (!_otpSent) ...[
              const Text('Phone Number',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+20 1XX XXX XXXX',
                  prefixIcon:
                      Icon(Icons.phone, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Send OTP',
                onPressed: _sendOtp,
                isLoading: _isLoading,
              ),
            ],

            // ── OTP field ────────────────────────────────
            if (_otpSent) ...[
              const Text('Verification Code',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 8),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: '------',
                  prefixIcon: Icon(Icons.lock_outline,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Verify & Sign Up',
                onPressed: _verifyOtp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: const Text('Resend OTP',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}