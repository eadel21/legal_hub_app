import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';

class AccountInfoScreen extends StatefulWidget {
  final UserModel? user;
  const AccountInfoScreen({super.key, this.user});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _maritalCtrl;
  late final TextEditingController _genderCtrl;
  late final TextEditingController _nationalityCtrl;
  late final TextEditingController _emailCtrl;
  final _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user?.fullName ?? '');
    _maritalCtrl =
        TextEditingController(text: widget.user?.maritalStatus ?? '');
    _genderCtrl = TextEditingController(text: widget.user?.gender ?? '');
    _nationalityCtrl =
        TextEditingController(text: widget.user?.nationality ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestoreService.updateUser(uid, {
      'fullName': _nameCtrl.text.trim(),
      'maritalStatus': _maritalCtrl.text.trim(),
      'gender': _genderCtrl.text.trim(),
      'nationality': _nationalityCtrl.text.trim(),
    });
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')));
    Navigator.pop(context);
  }

  Widget _field(String label, TextEditingController ctrl,
      {String hint = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
            controller: ctrl,
            decoration: InputDecoration(hintText: hint.isEmpty ? label : hint)),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field('full name :', _nameCtrl, hint: 'enter the name'),
            _field(
                'Marital Status (Single / Married / Divorced / Widowed)',
                _maritalCtrl,
                hint: 'enter the marital status'),
            _field('Gender:', _genderCtrl, hint: 'Male Or Female'),
            _field('Nationality:', _nationalityCtrl,
                hint: 'enter the nationality!'),
            _field('Email Address:', _emailCtrl,
                hint: 'enter the email'),
            CustomButton(
                text: 'Submit',
                onPressed: _submit,
                isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}