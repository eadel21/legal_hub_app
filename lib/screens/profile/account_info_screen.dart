import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key, UserModel? user});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final UserModel? user = await _firestoreService.getUser(uid);

    if (user != null && mounted) {
      setState(() {
        _nameController.text = user.fullName;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _genderController.text = user.gender;
        _nationalityController.text = user.nationality;
        _maritalStatusController.text = user.maritalStatus;
        _photoUrl = user.photoUrl;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      await _firestoreService.updateUser(uid, {
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'gender': _genderController.text.trim(),
        'nationality': _nationalityController.text.trim(),
        'maritalStatus': _maritalStatusController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account information updated successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _nationalityController.dispose();
    _maritalStatusController.dispose();
    super.dispose();
  }

  Widget _buildInfoField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade300),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 110,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(60),
        image: _photoUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(_photoUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _photoUrl.isEmpty
          ? const Icon(Icons.person, size: 60, color: Colors.white)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Account Information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(child: _buildProfileImage()),
                  const SizedBox(height: 35),

                  _buildInfoField(
                    icon: Icons.person,
                    controller: _nameController,
                    hint: 'Full Name',
                  ),
                  _buildInfoField(
                    icon: Icons.email,
                    controller: _emailController,
                    hint: 'Email Address',
                    enabled: false,
                  ),
                  _buildInfoField(
                    icon: Icons.phone,
                    controller: _phoneController,
                    hint: 'Phone Number',
                  ),
                  _buildInfoField(
                    icon: Icons.person_outline,
                    controller: _genderController,
                    hint: 'Gender',
                  ),
                  _buildInfoField(
                    icon: Icons.flag,
                    controller: _nationalityController,
                    hint: 'Nationality',
                  ),
                  _buildInfoField(
                    icon: Icons.favorite_border,
                    controller: _maritalStatusController,
                    hint: 'Marital Status',
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 230,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'EDIT YOUR ACCOUNT INFORMATION',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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