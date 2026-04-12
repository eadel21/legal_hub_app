import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../lawyer/law_details_screen.dart';

class CrimeScreen extends StatelessWidget {
  const CrimeScreen({super.key});

  static final List<Map<String, dynamic>> _items = [
    {
      'title': 'Criminal Liability',
      'icon': Icons.gavel,
      'color': Color(0xFFE53935),
      'content': [
        {
          'heading': '1. Definition',
          'body': 'Criminal liability arises when a person commits an act prohibited by law. It requires both a criminal act and criminal intent.',
        },
        {
          'heading': '2. Elements of a Crime',
          'body': 'A crime consists of:\n• Legal element (prohibited by law)\n• Material element (the act itself)\n• Moral element (intent or negligence)',
        },
        {
          'heading': '3. Criminal Responsibility Age',
          'body': 'In Egypt, criminal responsibility starts at age 7 with limited liability. Full criminal responsibility begins at age 18.',
        },
      ],
    },
    {
      'title': 'Types of Crimes',
      'icon': Icons.warning_amber_outlined,
      'color': Color(0xFFFF6F00),
      'content': [
        {
          'heading': '1. Felonies',
          'body': 'Serious crimes punishable by imprisonment of more than 3 years, life sentence, or death penalty.',
        },
        {
          'heading': '2. Misdemeanors',
          'body': 'Crimes punishable by imprisonment from 24 hours to 3 years or a fine.',
        },
        {
          'heading': '3. Violations (Contraventions)',
          'body': 'Minor offenses punishable by small fines or up to 24 hours detention.',
        },
      ],
    },
    {
      'title': 'Rights of the Accused',
      'icon': Icons.shield_outlined,
      'color': Color(0xFF1565C0),
      'content': [
        {
          'heading': '1. Right to Legal Representation',
          'body': 'Every accused person has the right to a lawyer at all stages of investigation and trial.',
        },
        {
          'heading': '2. Presumption of Innocence',
          'body': 'Every person is presumed innocent until proven guilty by a final court judgment.',
        },
        {
          'heading': '3. Right to a Fair Trial',
          'body': 'The accused has the right to be heard, present evidence, and cross-examine witnesses.',
        },
        {
          'heading': '4. Protection Against Torture',
          'body': 'Any confession obtained under duress or torture is legally invalid and inadmissible.',
        },
      ],
    },
    {
      'title': 'Criminal Penalties',
      'icon': Icons.balance_outlined,
      'color': Color(0xFF6A1B9A),
      'content': [
        {
          'heading': '1. Death Penalty',
          'body': 'Applied for the most serious crimes such as premeditated murder, terrorism, and drug trafficking.',
        },
        {
          'heading': '2. Life Imprisonment',
          'body': 'Imprisonment for life, sometimes commuted to 25 years based on good behavior.',
        },
        {
          'heading': '3. Fixed-Term Imprisonment',
          'body': 'Ranges from 3 to 15 years for serious felonies.',
        },
        {
          'heading': '4. Fines',
          'body': 'Financial penalties imposed alone or alongside imprisonment depending on the crime.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criminal Law')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.gavel, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Criminal Law',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Crimes, penalties and rights of the accused',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 60),
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        (item['color'] as Color).withValues(alpha: 0.15),
                    child: Icon(item['icon'] as IconData,
                        color: item['color'] as Color, size: 20),
                  ),
                  title: Text(item['title'],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('View the information',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.grey),
                  onTap: () => _showDetail(context, item),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const LawDetailsScreen(categoryName: 'Crime'),
                  ),
                ),
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('Book an Appointment',
                    style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Map<String, dynamic> item) {
    final content = item['content'] as List<Map<String, String>>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(item['title'])),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: content.map((section) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section['heading']!,
                          style: TextStyle(
                              color: item['color'] as Color,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const SizedBox(height: 10),
                      Text(section['body']!,
                          style: const TextStyle(
                              fontSize: 14, height: 1.6)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}