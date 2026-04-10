import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import 'new_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId, required String phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  bool _isLoading = false;
  final _authService = AuthService();

  Future<void> _verify() async {
    if (_otp.length < 4) return;
    setState(() => _isLoading = true);
    try {
      await _authService.verifyOtp(
        verificationId: widget.verificationId,
        otp: _otp,
      );
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const NewPasswordScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text('OTP VERIFICATION',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  'Enter the OTP sent to your phone number',
                  style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 40),
              PinCodeTextField(
                appContext: context,
                length: 4,
                onChanged: (val) => _otp = val,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: Colors.white,
                  inactiveFillColor: AppColors.inputFill,
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
              ),
              const Spacer(),
              CustomButton(
                  text: 'Submit',
                  onPressed: _verify,
                  isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}