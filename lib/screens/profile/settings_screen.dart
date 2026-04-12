import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool get _isArabic {
    try {
      return context.locale.languageCode == 'ar';
    } catch (_) {
      return false;
    }
  }

  void _toggleLanguage() {
    try {
      final isEn = context.locale.languageCode == 'en';
      context.setLocale(isEn ? const Locale('ar') : const Locale('en'));
    } catch (e) {
      debugPrint('Language toggle error: $e');
    }
  }

  String _t(String key, String fallback) {
    try {
      final r = key.tr();
      return r == key ? fallback : r;
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('settings', 'Settings')),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: ListView(
        children: [

          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primary),
            title: Text(
              _t('language', 'Language'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _isArabic ? 'العربية' : 'English',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            trailing: GestureDetector(
              onTap: _toggleLanguage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.swap_horiz, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    _isArabic ? 'English' : 'العربية',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ]),
              ),
            ),
            onTap: _toggleLanguage,
          ),
          const Divider(height: 1),

          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined,
                color: AppColors.primary),
            title: Text(
              _t('notifications', 'Notifications'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            value: _notifications,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _notifications = val),
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined,
                color: AppColors.primary),
            title: Text(
              _t('privacy', 'Privacy Policy'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(_t('privacy', 'Privacy Policy')),
                content: Text(_t(
                  'privacy_content',
                  'Legal Hub respects your privacy. Your personal data is '
                  'stored securely and never shared with third parties '
                  'without your consent.',
                )),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: Text(
              _t('about', 'About'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Text('1.0.0',
                style: TextStyle(color: AppColors.textGrey)),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Legal Hub',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2026 Legal Hub. All rights reserved.',
            ),
          ),
        ],
      ),
    );
  }
}