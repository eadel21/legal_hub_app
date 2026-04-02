import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore_service.dart';
import '../categories/category_detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  int _currentBanner = 0;
  final _firestoreService = FirestoreService();
  String _userName = '';

  // ✅ Dynamic banners — fetched from Firestore
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  final List<String> _bannerTexts = [
    'Thinking about all the questions of the judiciary',
    'Are you looking for a specific question?',
    'Do you want trusted people in the field of law?',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final user = await _firestoreService.getUser(uid);
      if (mounted) setState(() => _userName = user?.fullName ?? '');
    }
    final cats = await _firestoreService.getCategories();
    if (mounted) {
      setState(() {
        _categories = cats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _currentTab == 0
            ? _buildHome()
            : _currentTab == 1
                ? const Center(child: Text('Find'))
                : const ProfileScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Find'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 10),
              Text(_userName.isEmpty ? 'Welcome' : _userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              const Icon(Icons.send_outlined, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Dynamic Banner Slider
          CarouselSlider.builder(
            itemCount: _bannerTexts.length,
            itemBuilder: (context, index, _) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _bannerTexts[index],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              );
            },
            options: CarouselOptions(
              height: 160,
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (i, _) =>
                  setState(() => _currentBanner = i),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentBanner,
              count: _bannerTexts.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ✅ Dynamic Categories Grid from Firestore
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _categories.isEmpty
                  ? _staticCategoryGrid()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return _categoryCard(
                          cat['name'] ?? '',
                          cat['icon'] ?? 'assets/icons/default.png',
                          cat['id'] ?? '',
                        );
                      },
                    ),
        ],
      ),
    );
  }

  // Fallback static grid if Firestore is empty
  Widget _staticCategoryGrid() {
    final items = [
      {'name': 'Personal status', 'icon': Icons.person_outline},
      {'name': 'crime', 'icon': Icons.gavel},
      {'name': 'Financial', 'icon': Icons.attach_money},
      {'name': 'companies', 'icon': Icons.business},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryDetailScreen(
                categoryName: items[index]['name'] as String,
                categoryId: items[index]['name'] as String,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(items[index]['icon'] as IconData, size: 48),
                const SizedBox(height: 10),
                Text(items[index]['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _categoryCard(String name, String iconPath, String id) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryDetailScreen(
              categoryName: name, categoryId: id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 48,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.category, size: 48)),
            const SizedBox(height: 10),
            Text(name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}