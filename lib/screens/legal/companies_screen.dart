import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../lawyer/law_details_screen.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  static final List<Map<String, dynamic>> _items = [
    {
      'title': 'Company Formation',
      'icon': Icons.business_outlined,
      'color': Color(0xFF0277BD),
      'content': [
        {
          'heading': '1. Types of Companies',
          'body': 'Main types in Egypt:\n• Sole proprietorship\n• Partnership\n• Limited Liability Company (LLC)\n• Joint Stock Company (JSC)',
        },
        {
          'heading': '2. Registration Requirements',
          'body': 'To register a company you need:\n• Trade name reservation\n• Articles of association\n• Minimum capital deposit\n• Registration with GAFI or commercial registry',
        },
        {
          'heading': '3. Minimum Capital',
          'body': 'LLCs require a minimum capital of EGP 1,000. JSCs require a minimum of EGP 250,000.',
        },
      ],
    },
    {
      'title': 'Corporate Governance',
      'icon': Icons.account_tree_outlined,
      'color': Color(0xFF2E7D32),
      'content': [
        {
          'heading': '1. Board of Directors',
          'body': 'JSCs must have a board of directors with at least 3 members responsible for managing the company.',
        },
        {
          'heading': '2. Shareholders Rights',
          'body': 'Shareholders have the right to:\n• Vote in general assemblies\n• Receive dividends\n• Inspect company records\n• Transfer shares',
        },
        {
          'heading': '3. Annual General Meeting',
          'body': 'Companies must hold an annual general meeting within 3 months of the financial year end to review accounts and elect directors.',
        },
      ],
    },
    {
      'title': 'Commercial Contracts',
      'icon': Icons.handshake_outlined,
      'color': Color(0xFFAD1457),
      'content': [
        {
          'heading': '1. Types of Commercial Contracts',
          'body': 'Common commercial contracts include:\n• Sale agreements\n• Distribution agreements\n• Agency contracts\n• Franchise agreements',
        },
        {
          'heading': '2. Contract Enforcement',
          'body': 'Commercial contracts are enforceable through the Economic Courts in Egypt, which specialize in commercial disputes.',
        },
        {
          'heading': '3. Penalty Clauses',
          'body': 'Contracts may include penalty clauses for breach. Courts may reduce excessive penalties if they are disproportionate to the actual damage.',
        },
      ],
    },
    {
      'title': 'Company Dissolution',
      'icon': Icons.cancel_outlined,
      'color': Color(0xFFBF360C),
      'content': [
        {
          'heading': '1. Voluntary Dissolution',
          'body': 'Shareholders may vote to dissolve the company voluntarily. A liquidator is appointed to settle debts and distribute remaining assets.',
        },
        {
          'heading': '2. Compulsory Dissolution',
          'body': 'Courts may order dissolution in cases of insolvency, illegal activities, or failure to meet legal requirements.',
        },
        {
          'heading': '3. Liquidation Process',
          'body': 'During liquidation:\n• All debts are settled first\n• Remaining assets are distributed to shareholders\n• Company is removed from the commercial registry',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Companies Law')),
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
                Icon(Icons.business, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Companies Law',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Formation, governance & dissolution',
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
                    builder: (_) => const LawDetailsScreen(
                        categoryName: 'Companies'),
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