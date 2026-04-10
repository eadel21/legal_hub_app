import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore_service.dart';

class PersonalStatusScreen extends StatefulWidget {
  const PersonalStatusScreen({super.key});

  @override
  State<PersonalStatusScreen> createState() => _PersonalStatusScreenState();
}

class _PersonalStatusScreenState extends State<PersonalStatusScreen> {
  final _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalityController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedMaritalStatus = 'Single';
  bool _isLoading = true;
  bool _isSaving = false;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final user = await _firestoreService.getUser(uid);
      if (user != null && mounted) {
        setState(() {
          _fullNameController.text = user.fullName;
          _phoneController.text = user.phone;
          _nationalityController.text = user.nationality;
          _selectedGender = user.gender.isNotEmpty ? user.gender : 'Male';
          _selectedMaritalStatus = user.maritalStatus.isNotEmpty ? user.maritalStatus : 'Single';
        });
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestoreService.updateUser(uid, {
        'fullName': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'nationality': _nationalityController.text.trim(),
        'gender': _selectedGender,
        'maritalStatus': _selectedMaritalStatus,
      });
    }
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal status updated successfully'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Personal Status',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.person,
                                size: 50, color: AppColors.primary),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildLabel('Full Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _fullNameController,
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v!.isEmpty ? 'Full name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Phone Number'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Nationality'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nationalityController,
                      hint: 'Enter your nationality',
                      icon: Icons.flag_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Gender'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedGender,
                      items: _genders,
                      icon: Icons.wc_outlined,
                      onChanged: (v) => setState(() => _selectedGender = v!),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Marital Status'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedMaritalStatus,
                      items: _maritalStatuses,
                      icon: Icons.favorite_outline,
                      onChanged: (v) =>
                          setState(() => _selectedMaritalStatus = v!),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Save Changes',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textDark));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}