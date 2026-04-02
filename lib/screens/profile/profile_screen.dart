import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';
import 'account_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  UserModel? _user;

  // ✅ Dynamic menu items — easy to add more
  late final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.person_outline,
      'title': 'Account Information',
      'subtitle': 'Change your account information',
      'onTap': () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => AccountInfoScreen(user: _user))),
    },
    {
      'icon': Icons.credit_card,
      'title': 'insurance detail',
      'subtitle': 'Add your insurance info',
      'onTap': () {},
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'title': 'Bank card details',
      'subtitle': 'Change your Bank card details',
      'onTap': () {},
    },
    {
      'icon': Icons.calendar_today_outlined,
      'title': 'My Appointments',
      'subtitle': 'Check your appointments',
      'onTap': () {},
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Settings',
      'subtitle': 'manage & Setting',
      'onTap': () {},
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text('Profile',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.send_outlined,
                      color: AppColors.primary),
                ],
              ),
            ),

            // ✅ Dynamic user info card
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
                            color: Colors.white, size: 30)),
                    const SizedBox(width: 12),
                    Column(
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

            // ✅ Dynamic menu list
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: Icon(item['icon'] as IconData,
                          color: Colors.white, size: 20),
                    ),
                    title: Text(item['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(item['subtitle'],
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: item['onTap'] as VoidCallback,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () async {
                  await _authService.signOut();
                  if (!mounted) return;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text('Sign Out',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}