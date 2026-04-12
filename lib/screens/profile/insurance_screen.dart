import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  final _providerController = TextEditingController();
  final _policyController = TextEditingController();
  final _holderController = TextEditingController();
  final _expiryController = TextEditingController();
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadInsurance();
  }

  Future<void> _loadInsurance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('insurance')
          .doc('info')
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _providerController.text = data['provider'] ?? '';
        _policyController.text   = data['policyNumber'] ?? '';
        _holderController.text   = data['holderName'] ?? '';
        _expiryController.text   = data['expiryDate'] ?? '';
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
          .collection('insurance')
          .doc('info')
          .set({
        'provider':     _providerController.text.trim(),
        'policyNumber': _policyController.text.trim(),
        'holderName':   _holderController.text.trim(),
        'expiryDate':   _expiryController.text.trim(),
        'updatedAt':    FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Insurance info saved'),
            backgroundColor: AppColors.primary),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text,
      IconData icon = Icons.info_outline}) {
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
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insurance Detail')),
      body: _isFetching
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header card ────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.credit_card,
                            color: Colors.white, size: 32),
                        SizedBox(height: 8),
                        Text('Insurance Information',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Add or update your insurance details',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _field('Insurance Provider', _providerController,
                      icon: Icons.business_outlined),
                  _field('Policy Number', _policyController,
                      icon: Icons.numbers_outlined),
                  _field('Policy Holder Name', _holderController,
                      icon: Icons.person_outline),
                  _field('Expiry Date', _expiryController,
                      icon: Icons.calendar_today_outlined),

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
                          : const Text('Save Insurance Info',
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
    _providerController.dispose();
    _policyController.dispose();
    _holderController.dispose();
    _expiryController.dispose();
    super.dispose();
  }
}