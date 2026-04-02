import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _continue() async {
    if (_phoneController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await _authService.verifyPhone(
      phoneNumber: _phoneController.text.trim(),
      onCodeSent: (verificationId) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OtpScreen(verificationId: verificationId),
          ),
        );
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text('Forgot Password?',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text(
                "Don't worry ! It happens. Please enter the phone number we will send the OTP in this phone number.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: 'Enter the phone Number'),
              ),
              const Spacer(),
              CustomButton(
                  text: 'Continue',
                  onPressed: _continue,
                  isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}