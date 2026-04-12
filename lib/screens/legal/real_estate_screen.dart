import 'package:flutter/material.dart';
import 'package:legal_hub_app/screens/legal/real_estate_detail.dart';
import '../../constants/app_colors.dart';

class RealEstateScreen extends StatelessWidget {
  const RealEstateScreen({super.key});

  static final List<Map<String, dynamic>> services = [
    {
      'title': 'Purchasing',
      'icon': Icons.home_outlined,
      'color': Colors.blue.shade700,
      'content': [
        {
          'heading': '1. Legal Ownership Verification',
          'body':
              'Before purchasing any property, the buyer must verify that the seller is the legal owner. This includes checking property titles, ownership documents, and confirming that the property is registered with the official real estate authority.',
        },
        {
          'heading': '2. Property Registration',
          'body':
              'After the purchase agreement is completed, the property must be officially registered in the buyer\'s name through government registration offices. Registration ensures the buyer\'s legal ownership and protects against future disputes.',
        },
        {
          'heading': '3. Purchase Agreement (Contract)',
          'body':
              'A written contract must be prepared and signed by both buyer and seller. The contract usually includes:\n• Property details\n• Purchase price\n• Payment terms\n• Delivery date\n• Responsibilities of both parties',
        },
        {
          'heading': '4. Payment and Financial Regulations',
          'body':
              'Payments must follow legal financial procedures. In many countries, payments are made through bank transfers or certified checks to prevent fraud and ensure transparency.',
        },
        {
          'heading': '5. Taxes and Fees',
          'body':
              'Buyers are usually required to pay certain costs such as:\n• Property registration fees\n• Real estate taxes\n• Legal or administrative fees',
        },
      ],
    },
    {
      'title': 'Selling',
      'icon': Icons.sell_outlined,
      'color': Colors.orange.shade700,
      'content': [
        {
          'heading': '1. Proof of Ownership',
          'body':
              'The seller must provide valid documents proving legal ownership of the property before any sale transaction begins.',
        },
        {
          'heading': '2. Property Valuation',
          'body':
              'A professional valuation helps determine a fair market price. This protects both the seller and buyer during negotiations.',
        },
        {
          'heading': '3. Sale Agreement',
          'body':
              'A legally binding sale agreement must be signed by both parties, including:\n• Agreed price\n• Payment method\n• Handover date\n• Included fixtures',
        },
        {
          'heading': '4. Transfer of Ownership',
          'body':
              'Once payment is made, the property title must be officially transferred at the relevant government authority.',
        },
        {
          'heading': '5. Capital Gains Tax',
          'body':
              'Sellers may be liable for capital gains tax depending on the jurisdiction and profit made from the sale.',
        },
      ],
    },
    {
      'title': 'Rent',
      'icon': Icons.apartment_outlined,
      'color': Colors.teal.shade700,
      'content': [
        {
          'heading': '1. Rental Agreement',
          'body':
              'A written rental contract must be signed between landlord and tenant specifying rent amount, duration, and responsibilities.',
        },
        {
          'heading': '2. Security Deposit',
          'body':
              'Landlords may request a security deposit, typically equal to 1-3 months rent, to cover potential damages or unpaid rent.',
        },
        {
          'heading': '3. Tenant Rights',
          'body':
              'Tenants have the right to:\n• Habitable living conditions\n• Privacy and quiet enjoyment\n• Proper notice before entry\n• Return of security deposit',
        },
        {
          'heading': '4. Landlord Obligations',
          'body':
              'Landlords must maintain the property, handle repairs promptly, and follow legal eviction procedures if needed.',
        },
        {
          'heading': '5. Lease Renewal',
          'body':
              'Both parties must agree on renewal terms before the lease expires. Automatic renewals may apply under local law.',
        },
      ],
    },
    {
      'title': 'Real Estate Brokerage',
      'icon': Icons.handshake_outlined,
      'color': Colors.purple.shade700,
      'content': [
        {
          'heading': '1. Broker Licensing',
          'body':
              'Real estate brokers must be licensed by the relevant authority to legally operate and represent clients in property transactions.',
        },
        {
          'heading': '2. Broker Commission',
          'body':
              'Brokers typically earn a commission of 2-5% of the property sale price, paid upon successful transaction completion.',
        },
        {
          'heading': '3. Broker Duties',
          'body':
              'A broker must:\n• Act in the best interest of the client\n• Disclose all material facts\n• Maintain confidentiality\n• Present all offers to the client',
        },
        {
          'heading': '4. Brokerage Agreement',
          'body':
              'A written agreement between the client and broker must define the scope, duration, and terms of the brokerage relationship.',
        },
      ],
    },
    {
      'title': 'Property Evacuation',
      'icon': Icons.exit_to_app_outlined,
      'color': Colors.red.shade700,
      'content': [
        {
          'heading': '1. Legal Reasons for Eviction',
          'body':
              'A landlord can request property evacuation only for valid legal reasons, such as:\n• Failure to pay rent\n• Violation of lease agreement terms\n• Property misuse or illegal activities\n• Expiration of the rental contract without renewal\n• Landlord\'s legal need to use or sell the property',
        },
        {
          'heading': '2. Official Notice Requirement',
          'body':
              'Before eviction, landlords must provide a written notice to the tenant. The notice usually includes:\n• Reason for eviction\n• Time period given to fix the violation or leave the property\n• Date of eviction if the issue is not resolved',
        },
        {
          'heading': '3. Legal Procedures',
          'body':
              'Eviction must follow official legal procedures through courts or authorized authorities. Landlords are not allowed to remove tenants by force, change locks, or cut utilities without legal approval.',
        },
        {
          'heading': '4. Tenant Rights',
          'body':
              'Tenants have the right to:\n• Receive proper legal notice\n• Challenge eviction in court\n• Stay in the property until a legal eviction order is issued\n• Collect personal belongings before leaving',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real Estate Law')),
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
                Icon(Icons.location_city, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Real Estate Law',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Property buying, selling and rental laws',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: services.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 60),
              itemBuilder: (context, index) {
                final item = services[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        (item['color'] as Color).withValues(alpha: 0.15),
                    child: Icon(item['icon'] as IconData,
                        color: item['color'] as Color, size: 20),
                  ),
                  title: Text(item['title'],
                      style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('View the information',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.grey),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RealEstateDetailScreen(
                        title: item['title'],
                        color: item['color'] as Color,
                        icon: item['icon'] as IconData,
                        content: item['content']
                            as List<Map<String, String>>,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}