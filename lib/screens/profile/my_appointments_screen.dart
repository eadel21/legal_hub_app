import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
    .collection('appointments')
    .where('userId', isEqualTo: uid)
    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: AppColors.primary));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 64, color: AppColors.textGrey),
                  SizedBox(height: 16),
                  Text('No appointments yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Text(
                    'Book a lawyer to see your\nappointments here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;
              final status = data['status'] ?? 'pending';

              Color statusColor;
              Color statusBg;
              switch (status) {
                case 'confirmed':
                  statusColor = Colors.green.shade700;
                  statusBg = Colors.green.shade100;
                  break;
                case 'cancelled':
                  statusColor = Colors.red.shade700;
                  statusBg = Colors.red.shade100;
                  break;
                default:
                  statusColor = Colors.orange.shade700;
                  statusBg = Colors.orange.shade100;
              }

              return Container(
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
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['lawyerName'] ?? 'Unknown',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(data['specialty'] ?? '',
                              style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 12,
                                  color: AppColors.textGrey),
                              const SizedBox(width: 4),
                              Text(
                                '${data['date'] ?? ''} at ${data['time'] ?? ''}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.videocam_outlined,
                                  size: 12,
                                  color: AppColors.textGrey),
                              const SizedBox(width: 4),
                              Text(
                                data['consultationType'] ?? '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}