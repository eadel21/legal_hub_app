import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore_service.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const CategoryDetailScreen(
      {super.key, required this.categoryName, required this.categoryId});

  @override
  State<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    // ✅ Dynamic — items loaded from Firestore subcollection
    final items =
        await _firestoreService.getCategoryItems(widget.categoryId);
    if (mounted) setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No content available'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.circle,
                            color: Colors.green, size: 10),
                      ),
                      title: Text(item['title'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      subtitle: const Text('View the information'),
                      onTap: () {
                        // Navigate to detail content
                      },
                    );
                  },
                ),
    );
  }
}