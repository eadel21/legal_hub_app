import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';
import 'account_info_screen.dart';
import 'insurance_screen.dart';
import 'bank_card_screen.dart';
import 'my_appointments_screen.dart';
import 'settings_screen.dart';
import '../lawyer/apply_as_lawyer_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  UserModel? _user;

  List<Map<String, dynamic>> get _menuItems => [
    {
      'icon': Icons.person_outline,
      'title': 'Account Information',
      'subtitle': 'Change your account information',
      'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AccountInfoScreen(user: _user))),
    },
    {
      'icon': Icons.credit_card,
      'title': 'Insurance Detail',
      'subtitle': 'Add your insurance info',
      'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InsuranceScreen())),
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'title': 'Bank Card Details',
      'subtitle': 'Change your bank card details',
      'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BankCardScreen())),
    },
    {
      'icon': Icons.calendar_today_outlined,
      'title': 'My Appointments',
      'subtitle': 'Check your appointments',
      'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const MyAppointmentsScreen())),
    },
    {
      'icon': Icons.gavel_outlined,
      'title': 'Apply as a Lawyer',
      'subtitle': 'Join our legal network',
      'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const ApplyAsLawyerScreen())),
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Settings',
      'subtitle': 'Manage & settings',
      'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen())),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final user = await _firestoreService.getUser(uid);
      if (mounted) setState(() => _user = user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Profile',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(Icons.send_outlined, color: AppColors.primary),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user?.fullName.toUpperCase() ?? 'LOADING...',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            _user?.email ?? '',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AccountInfoScreen(user: _user),
                          ),
                        );
                        _loadUser();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.edit,
                                color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Edit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
              child: Text('General',
                  style: TextStyle(
                      color: AppColors.textGrey, fontSize: 14)),
            ),

            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  final isLawyer = item['title'] == 'Apply as a Lawyer';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isLawyer
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.accent,
                      child: Icon(item['icon'] as IconData,
                          color: isLawyer
                              ? AppColors.primary
                              : Colors.white,
                          size: 20),
                    ),
                    title: Text(item['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isLawyer
                                ? AppColors.primary
                                : AppColors.textDark)),
                    subtitle: Text(item['subtitle'],
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right,
                        color: Colors.grey),
                    onTap: item['onTap'] as VoidCallback,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () async {
                  await _authService.signOut();
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sign Out',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}