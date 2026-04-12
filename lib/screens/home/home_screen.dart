import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../find/find_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore_service.dart';
import '../categories/category_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../legal/personal_status_screen.dart';
import '../legal/crime_screen.dart';
import '../legal/financial_screen.dart';
import '../legal/companies_screen.dart';
import '../legal/real_estate_screen.dart';
import '../chat/chat_list_screen.dart';

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
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _banners = [
    {
      'text': 'Thinking about all the questions of the judiciary',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'text': 'Are you looking for a specific question?',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'text': 'Do you want trusted people in the field of law?',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  final List<Map<String, dynamic>> _staticCategories = [
    {'name': 'Personal Status', 'icon': Icons.person_outline},
    {'name': 'Crime', 'icon': Icons.gavel},
    {'name': 'Financial', 'icon': Icons.attach_money},
    {'name': 'Companies', 'icon': Icons.business},
    {'name': 'Real Estate', 'icon': Icons.location_city},
  ];

  Widget _getScreenForCategory(String name, String id) {
    switch (name.toLowerCase().trim()) {
      case 'personal status':
      case 'personal status law':
      case 'personal_status':
        return const PersonalStatusScreen();
      case 'crime':
      case 'criminal law':
      case 'criminal':
        return const CrimeScreen();
      case 'financial':
      case 'financial law':
      case 'finance':
        return const FinancialScreen();
      case 'companies':
      case 'companies law':
      case 'company':
      case 'corporate':
        return const CompaniesScreen();
      case 'real estate':
      case 'real estate law':
      case 'realestate':
      case 'real_estate':
        return const RealEstateScreen();
      default:
        debugPrint('⚠️ No screen found for category: "$name" — using fallback');
        return CategoryDetailScreen(categoryName: name, categoryId: id);
    }
  }

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

    try {
      final cats = await _firestoreService.getCategories();
      debugPrint(
          '📦 Categories from Firestore: ${cats.map((c) => c['name']).toList()}');
      if (mounted) {
        setState(() {
          _categories = cats;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to load categories: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
  final _ = context.locale;
    return Scaffold(
      backgroundColor: AppColors.background,
body: SafeArea(
  child: _currentTab == 0
      ? _buildHome()
      : _currentTab == 1
          ? _buildSearch()
          : _currentTab == 2
              ? const ChatListScreen()
              : const ProfileScreen(),
),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Find'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            activeIcon: Icon(Icons.person), 
            label: 'Profile'),

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
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary,
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  Text(
                    _userName.isEmpty ? 'User' : _userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => setState(() => _currentTab = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text('Search for a lawyer or case type...',
                      style: TextStyle(color: AppColors.textGrey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CarouselSlider.builder(
            itemCount: _banners.length,
            itemBuilder: (context, index, _) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        _banners[index]['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.primary),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      _banners[index]['text'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: 180,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (i, _) => setState(() => _currentBanner = i),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentBanner,
              count: _banners.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Legal Categories',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : _categories.isEmpty
                  ? _buildStaticGrid()
                  : _buildFirestoreGrid(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return const FindScreen();
  }

  Widget _buildStaticGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _staticCategories.length,
      itemBuilder: (context, index) {
        final name = _staticCategories[index]['name'] as String;
        final icon = _staticCategories[index]['icon'] as IconData;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _getScreenForCategory(name, name),
            ),
          ),
          child: _categoryCardWidget(
            name: name,
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
        );
      },
    );
  }

  Widget _buildFirestoreGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final name = cat['name'] ?? '';
        final id = cat['id'] ?? '';
        final iconPath = cat['icon'] ?? '';
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _getScreenForCategory(name, id),
            ),
          ),
          child: _categoryCardWidget(
            name: name,
            child: Image.asset(
              iconPath,
              height: 32,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.category,
                size: 32,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _categoryCardWidget({
    required String name,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: child,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
