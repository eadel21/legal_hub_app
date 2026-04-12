import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../services/firestore_service.dart';
import 'request_status_screen.dart';

class ApplyAsLawyerScreen extends StatefulWidget {
  const ApplyAsLawyerScreen({super.key});

  @override
  State<ApplyAsLawyerScreen> createState() => _ApplyAsLawyerScreenState();
}

class _ApplyAsLawyerScreenState extends State<ApplyAsLawyerScreen> {
  final _firestoreService = FirestoreService();
  int _currentStep = 0;

  // Step 1
  final _fullNameController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _unionNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _unionCardFileName;

  // Step 2
  final _specialtyController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  String? _licenseFileName;

  // Step 3
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();
  String? _nationalIdFileName;
  String? _photoFileName;

  bool _isSaving = false;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _graduationYearController.dispose();
    _unionNumberController.dispose();
    _experienceController.dispose();
    _specialtyController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(Function(String) onPicked) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      onPicked(result.files.first.name);
    }
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestoreService.submitLawyerApplication({
        'userId': uid,
        'fullName': _fullNameController.text.trim(),
        'graduationYear': _graduationYearController.text.trim(),
        'unionNumber': _unionNumberController.text.trim(),
        'experience': _experienceController.text.trim(),
        'specialty': _specialtyController.text.trim(),
        'city': _cityController.text.trim(),
        'bio': _bioController.text.trim(),
        'nationalId': _nationalIdController.text.trim(),
        'address': _addressController.text.trim(),
      });
    }
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RequestStatusScreen(status: 'pending'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Applying as a Lawyer',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _currentStep == 0
                  ? _buildStep1()
                  : _currentStep == 1
                      ? _buildStep2()
                      : _buildStep3(),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == _currentStep;
          final isDone = index < _currentStep;
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 36 : 28,
                height: isActive ? 36 : 28,
                decoration: BoxDecoration(
                  color: isDone || isActive
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.textGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (index < 2)
                Container(
                  width: 50,
                  height: 2,
                  color: index < _currentStep
                      ? AppColors.primary
                      : Colors.grey.shade300,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Professional Information'),
          const SizedBox(height: 20),
          _buildLabel('Full Name'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameController,
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Year of Graduation'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _graduationYearController,
            hint: 'e.g. 2018',
            icon: Icons.school_outlined,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Union Registration Number'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _unionNumberController,
            hint: 'Enter union registration number',
            icon: Icons.badge_outlined,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Years of Experience'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _experienceController,
            hint: 'e.g. 5',
            icon: Icons.work_outline,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _buildLabel('Union Membership Card'),
          const SizedBox(height: 8),
          _buildFileUpload(
            fileName: _unionCardFileName,
            onTap: () => _pickFile((name) =>
                setState(() => _unionCardFileName = name)),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Specialization & Location'),
          const SizedBox(height: 20),
          _buildLabel('Legal Specialty'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _specialtyController,
            hint: 'e.g. Criminal Law, Family Law',
            icon: Icons.gavel_outlined,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('City'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _cityController,
            hint: 'Enter your city',
            icon: Icons.location_city_outlined,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Bio / About You'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _bioController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe your experience and expertise...',
              hintStyle: const TextStyle(color: AppColors.textGrey),
              filled: true,
              fillColor: AppColors.inputFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Practice License'),
          const SizedBox(height: 8),
          _buildFileUpload(
            fileName: _licenseFileName,
            onTap: () => _pickFile((name) =>
                setState(() => _licenseFileName = name)),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Verification'),
          const SizedBox(height: 20),
          _buildLabel('National ID Number'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nationalIdController,
            hint: 'Enter your national ID number',
            icon: Icons.credit_card_outlined,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Address'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _addressController,
            hint: 'Enter your full address',
            icon: Icons.home_outlined,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _buildLabel('National ID Copy'),
          const SizedBox(height: 8),
          _buildFileUpload(
            fileName: _nationalIdFileName,
            onTap: () => _pickFile((name) =>
                setState(() => _nationalIdFileName = name)),
          ),
          const SizedBox(height: 16),
          _buildLabel('Personal Photo'),
          const SizedBox(height: 8),
          _buildFileUpload(
            fileName: _photoFileName,
            onTap: () => _pickFile(
                (name) => setState(() => _photoFileName = name)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving
                  ? null
                  : () {
                      final key = _currentStep == 0
                          ? _step1Key
                          : _currentStep == 1
                              ? _step2Key
                              : _step3Key;
                      if (key.currentState!.validate()) {
                        if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        } else {
                          _submit();
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _currentStep < 2 ? 'Next Step' : 'Submit',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark));
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

  Widget _buildFileUpload({
    required String? fileName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: fileName != null
                ? AppColors.primary
                : Colors.grey.shade300,
            width: fileName != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              fileName != null
                  ? Icons.check_circle
                  : Icons.upload_file_outlined,
              color: fileName != null ? AppColors.primary : AppColors.textGrey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileName ?? 'Tap to upload file',
                style: TextStyle(
                  color: fileName != null
                      ? AppColors.textDark
                      : AppColors.textGrey,
                  fontWeight: fileName != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Text(
              'UPLOAD',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}