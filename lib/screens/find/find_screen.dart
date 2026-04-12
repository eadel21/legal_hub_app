import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore_service.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({super.key});
  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  final _searchController = TextEditingController();
  final _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _lawyers = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLawyers();
  }

  Future<void> _loadLawyers() async {
    final lawyers = await _firestoreService.getLawyers();
    if (mounted) setState(() { _lawyers = lawyers; _filtered = lawyers; _isLoading = false; });
  }

  void _search(String query) {
    setState(() {
      _filtered = _lawyers.where((l) =>
        l['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        l['specialization'].toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Find a lawyer/Search for Consultion'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? Center(child: Text('No results found'.tr()))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            final lawyer = _filtered[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    lawyer['name']?.substring(0, 1).toUpperCase() ?? 'L',
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                title: Text(lawyer['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lawyer['specialization'] ?? ''),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        Text(' ${lawyer['rating'] ?? '0'}'),
                                        const SizedBox(width: 8),
                                        Text('${lawyer['experience'] ?? '0'} yrs'),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('book_appointment'.tr(),
                                      style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}