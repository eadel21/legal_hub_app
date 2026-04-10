import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  void _toggleLanguage() {
    final current = context.locale;
    if (current.languageCode == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
            title: Text('theme'.tr()),
            value: _darkMode,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primary),
            title: Text('language'.tr()),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isArabic ? 'English' : 'العربية',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: _toggleLanguage,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: AppColors.primary),
            title: Text('notifications'.tr()),
            value: _notifications,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _notifications = val),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppColors.primary),
            title: Text('privacy'.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: Text('about'.tr()),
            trailing: const Text('1.0.0', style: TextStyle(color: AppColors.textGrey)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}