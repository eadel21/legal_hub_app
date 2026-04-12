import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../lawyer/law_details_screen.dart';

class FinancialScreen extends StatelessWidget {
  const FinancialScreen({super.key});

  static final List<Map<String, dynamic>> _items = [
    {
      'title': 'Contracts & Obligations',
      'icon': Icons.description_outlined,
      'color': Color(0xFF1976D2),
      'content': [
        {
          'heading': '1. Valid Contract Requirements',
          'body': 'A valid contract requires:\n• Offer and acceptance\n• Legal capacity of both parties\n• Lawful subject matter\n• Agreed consideration (price)',
        },
        {
          'heading': '2. Breach of Contract',
          'body': 'A breach occurs when one party fails to fulfill their contractual obligations. The other party may seek compensation through the courts.',
        },
        {
          'heading': '3. Contract Termination',
          'body': 'Contracts can be terminated by mutual agreement, fulfillment of terms, court order, or due to impossibility of performance.',
        },
      ],
    },
    {
      'title': 'Banking & Loans',
      'icon': Icons.account_balance_outlined,
      'color': Color(0xFF388E3C),
      'content': [
        {
          'heading': '1. Loan Agreements',
          'body': 'Loan agreements must specify the amount, interest rate, repayment schedule, and consequences of default.',
        },
        {
          'heading': '2. Borrower Rights',
          'body': 'Borrowers have the right to:\n• Receive clear loan terms\n• Early repayment without excessive penalties\n• Dispute incorrect charges',
        },
        {
          'heading': '3. Debt Collection',
          'body': 'Creditors must follow legal procedures for debt collection. Harassment or illegal collection practices are prohibited.',
        },
      ],
    },
    {
      'title': 'Taxation',
      'icon': Icons.receipt_long_outlined,
      'color': Color(0xFFF57C00),
      'content': [
        {
          'heading': '1. Income Tax',
          'body': 'Individuals and businesses must file annual income tax returns. Rates vary based on income brackets.',
        },
        {
          'heading': '2. Value Added Tax (VAT)',
          'body': 'VAT of 14% applies to most goods and services in Egypt. Businesses must register if turnover exceeds the threshold.',
        },
        {
          'heading': '3. Tax Disputes',
          'body': 'Taxpayers can appeal tax assessments through the Tax Authority\'s internal review or through the courts.',
        },
      ],
    },
    {
      'title': 'Financial Disputes',
      'icon': Icons.balance_outlined,
      'color': Color(0xFFC62828),
      'content': [
        {
          'heading': '1. Civil Court Claims',
          'body': 'Financial disputes can be resolved through civil courts. The plaintiff must provide documented evidence of the claim.',
        },
        {
          'heading': '2. Arbitration',
          'body': 'Parties may agree to resolve disputes through arbitration, which is faster and more confidential than court proceedings.',
        },
        {
          'heading': '3. Mediation',
          'body': 'Mediation is a voluntary process where a neutral third party helps the disputing parties reach a mutually acceptable agreement.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Law')),
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
                Icon(Icons.attach_money, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Financial Law',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Contracts, banking, taxation & disputes',
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
                        categoryName: 'Financial'),
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