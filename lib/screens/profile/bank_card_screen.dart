import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';

class BankCardScreen extends StatefulWidget {
  const BankCardScreen({super.key});

  @override
  State<BankCardScreen> createState() => _BankCardScreenState();
}

class _BankCardScreenState extends State<BankCardScreen> {
  final _cardNameController   = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController     = TextEditingController();
  final _bankNameController   = TextEditingController();
  bool _isLoading  = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadCard();
  }

  Future<void> _loadCard() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bankCard')
          .doc('info')
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _cardNameController.text   = data['cardHolderName'] ?? '';
        _cardNumberController.text = data['cardNumber'] ?? '';
        _expiryController.text     = data['expiryDate'] ?? '';
        _bankNameController.text   = data['bankName'] ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _isFetching = false);
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bankCard')
          .doc('info')
          .set({
        'cardHolderName': _cardNameController.text.trim(),
        'cardNumber':     _cardNumberController.text.trim(),
        'expiryDate':     _expiryController.text.trim(),
        'bankName':       _bankNameController.text.trim(),
        'updatedAt':      FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bank card info saved'),
            backgroundColor: AppColors.primary),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text,
      IconData icon = Icons.info_outline,
      int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: type,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, color: AppColors.primary),
            counterText: '',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Card Details')),
      body: _isFetching
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Visual card preview ────────────────
                  Container(
                    width: double.infinity,
                    height: 180,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('BANK CARD',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    letterSpacing: 2)),
                            Icon(Icons.credit_card,
                                color: Colors.white, size: 28),
                          ],
                        ),
                        Text(
                          _cardNumberController.text.isEmpty
                              ? '**** **** **** ****'
                              : _cardNumberController.text,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _cardNameController.text.isEmpty
                                  ? 'CARD HOLDER'
                                  : _cardNameController.text
                                      .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                            Text(
                              _expiryController.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryController.text,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  _field('Card Holder Name', _cardNameController,
                      icon: Icons.person_outline),
                  _field('Card Number', _cardNumberController,
                      type: TextInputType.number,
                      icon: Icons.numbers_outlined,
                      maxLength: 16),
                  _field('Expiry Date (MM/YY)', _expiryController,
                      icon: Icons.calendar_today_outlined),
                  _field('Bank Name', _bankNameController,
                      icon: Icons.account_balance_outlined),

                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
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
                          : const Text('Save Card Info',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }
}