import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _usePhone = false; // false = email, true = phone

  Future<void> _submitEmail() async {
    if (_emailCtrl.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.sendPasswordResetEmail(_emailCtrl.text.trim());
      if (!mounted) return;
      _showSuccess('Password reset email sent! Check your inbox.');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitPhone() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    // Make sure number starts with + country code
    if (!phone.startsWith('+')) {
      _showError('Include country code e.g. +201012345678');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.sendOtpToPhone(
        phoneNumber: phone,
        onCodeSent: (verificationId) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                verificationId: verificationId,
                phoneNumber: phone,
              ),
            ),
          );
        },
        onError: (error) {
          if (mounted) {
            setState(() => _isLoading = false);
            _showError(error);
          }
        },
      );
    } catch (e) {
      _showError(e.toString());
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ── Icon ─────────────────────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_reset,
                    size: 48, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),

            // ── Title ────────────────────────────────────
            const Center(
              child: Text('Forgot Password',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Choose how you want to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 32),

            // ── Toggle Email / Phone ──────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _usePhone = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_usePhone
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email_outlined,
                                size: 18,
                                color: !_usePhone
                                    ? Colors.white
                                    : AppColors.textGrey),
                            const SizedBox(width: 6),
                            Text('Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: !_usePhone
                                        ? Colors.white
                                        : AppColors.textGrey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _usePhone = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _usePhone
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone_outlined,
                                size: 18,
                                color: _usePhone
                                    ? Colors.white
                                    : AppColors.textGrey),
                            const SizedBox(width: 6),
                            Text('Phone',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _usePhone
                                        ? Colors.white
                                        : AppColors.textGrey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Email Input ───────────────────────────────
            if (!_usePhone) ...[
              const Text('Email Address',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We will send a password reset link to your email.',
                style: TextStyle(
                    color: AppColors.textGrey, fontSize: 13),
              ),
            ],

            // ── Phone Input ───────────────────────────────
            if (_usePhone) ...[
              const Text('Phone Number',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+201012345678',
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We will send a 6-digit OTP to your phone number.',
                style: TextStyle(
                    color: AppColors.textGrey, fontSize: 13),
              ),
            ],

            const SizedBox(height: 24),

            // ── Submit Button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _usePhone
                        ? _submitPhone
                        : _submitEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _usePhone ? 'Send OTP' : 'Send Reset Email',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Back to Login ─────────────────────────────
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: RichText(
                  text: const TextSpan(
                    text: 'Remember your password? ',
                    style: TextStyle(color: AppColors.textGrey),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}