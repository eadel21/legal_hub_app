import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../lawyer/law_details_screen.dart';

class PersonalStatusScreen extends StatelessWidget {
  const PersonalStatusScreen({super.key});

  static final List<Map<String, dynamic>> _items = [
    {
      'title': 'Marriage',
      'icon': Icons.favorite_outline,
      'color': Color(0xFFE91E63),
      'content': [
        {
          'heading': '1. Marriage Contract',
          'body': 'A marriage contract is a legal document signed by both parties in the presence of witnesses and an authorized official. It defines the rights and obligations of each spouse.',
        },
        {
          'heading': '2. Legal Age for Marriage',
          'body': 'The legal minimum age for marriage varies by country. In Egypt, the minimum age is 18 for both males and females.',
        },
        {
          'heading': '3. Dowry (Mahr)',
          'body': 'The dowry is the husband\'s financial obligation to his wife, specified in the marriage contract. It consists of a prompt (immediate) and deferred portion.',
        },
        {
          'heading': '4. Marriage Registration',
          'body': 'All marriages must be officially registered with the civil registry to be legally recognized and to protect both parties\' rights.',
        },
      ],
    },
    {
      'title': 'Divorce',
      'icon': Icons.heart_broken_outlined,
      'color': Color(0xFF9C27B0),
      'content': [
        {
          'heading': '1. Types of Divorce',
          'body': 'Divorce can be:\n• Talaq (husband-initiated)\n• Khul\' (wife-initiated with financial concession)\n• Judicial divorce (court-ordered)',
        },
        {
          'heading': '2. Divorce Procedures',
          'body': 'Divorce must be registered officially. Judicial divorce requires filing a lawsuit and attending court sessions.',
        },
        {
          'heading': '3. Financial Rights After Divorce',
          'body': 'After divorce the wife is entitled to:\n• Deferred dowry\n• Alimony during waiting period (Iddah)\n• Compensation if divorce was without valid reason',
        },
        {
          'heading': '4. Waiting Period (Iddah)',
          'body': 'After divorce, the wife must observe a waiting period (3 menstrual cycles) before remarrying. During this time the husband must provide financial support.',
        },
      ],
    },
    {
      'title': 'Child Custody',
      'icon': Icons.child_care_outlined,
      'color': Color(0xFF2196F3),
      'content': [
        {
          'heading': '1. Custody Rights',
          'body': 'In Egyptian law, the mother has the right to physical custody of children — boys until age 15 and girls until they marry.',
        },
        {
          'heading': '2. Best Interest of the Child',
          'body': 'Courts always prioritize the best interest of the child when deciding custody arrangements.',
        },
        {
          'heading': '3. Visitation Rights',
          'body': 'The non-custodial parent has the right to regular visitation as determined by the court.',
        },
        {
          'heading': '4. Child Support',
          'body': 'The father is financially responsible for the child\'s upbringing regardless of custody arrangements.',
        },
      ],
    },
    {
      'title': 'Inheritance',
      'icon': Icons.account_balance_outlined,
      'color': Color(0xFF4CAF50),
      'content': [
        {
          'heading': '1. Legal Heirs',
          'body': 'Legal heirs include spouse, children, parents, and siblings, with shares defined by Islamic law and the Egyptian Civil Code.',
        },
        {
          'heading': '2. Will (Wasiyya)',
          'body': 'A person may leave a will for up to one-third of their estate to non-heirs. Wills must be officially documented.',
        },
        {
          'heading': '3. Estate Distribution',
          'body': 'After paying debts and funeral expenses, the remaining estate is distributed among heirs according to their legal shares.',
        },
        {
          'heading': '4. Inheritance Disputes',
          'body': 'Inheritance disputes are resolved through the Personal Status courts. A lawyer can help protect your rightful share.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Status Law')),
      body: Column(
        children: [
          // ── Header Banner ──────────────────────────────
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
                Icon(Icons.people_outline, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Personal Status Law',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Marriage, divorce, custody & inheritance',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),

          // ── List ───────────────────────────────────────
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

          // ── Book Appointment Button ────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LawDetailsScreen(
                        categoryName: 'Personal Status'),
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