import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import 'booking_screen.dart';

class LawDetailsScreen extends StatelessWidget {
  final String categoryName;

  const LawDetailsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // ✅ Build Firestore query dynamically
    Query query = FirebaseFirestore.instance.collection('lawyers');

    if (categoryName != 'All') {
      query = query.where('specialty', isEqualTo: categoryName);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Navigator.canPop(context)
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              )
            : null,
        title: Text(
          categoryName == 'All'
              ? 'LAW DETAILS:'
              : '${categoryName.toUpperCase()} LAWYERS:',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          // ── Loading ────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // ── Error ──────────────────────────────────────
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong',
                  style: TextStyle(color: Colors.white54)),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          // ── Empty ──────────────────────────────────────
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    categoryName == 'All'
                        ? 'No lawyers available yet'
                        : 'No lawyers available\nfor $categoryName yet',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // ── Grid ───────────────────────────────────────
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return _LawyerCard(
                lawyer: {
                  'id': docs[index].id,
                  'name': data['name'] ?? 'Unknown',
                  'specialty': data['specialty'] ?? '',
                  'rating': (data['rating'] ?? 0.0).toDouble(),
                  'photoUrl': data['photoUrl'] ?? '',
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _LawyerCard extends StatelessWidget {
  final Map<String, dynamic> lawyer;
  const _LawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Avatar ──────────────────────────────────────
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            backgroundImage: lawyer['photoUrl'] != ''
                ? NetworkImage(lawyer['photoUrl'])
                : null,
            child: lawyer['photoUrl'] == ''
                ? const Icon(Icons.person, color: Colors.white, size: 26)
                : null,
          ),
          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              lawyer['name'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),

          Text(
            lawyer['specialty'].toString().toUpperCase(),
            style: const TextStyle(color: Colors.white54, fontSize: 9),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lawyer['rating'].toStringAsFixed(1),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10)),
              const Icon(Icons.star, color: Colors.amber, size: 12),
            ],
          ),
          const SizedBox(height: 6),

          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(
                  lawyerId: lawyer['id'],
                  lawyerName: lawyer['name'],
                  specialty: lawyer['specialty'],
                  rating: lawyer['rating'],
                  photoUrl: lawyer['photoUrl'],
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('BOOK NOW',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}