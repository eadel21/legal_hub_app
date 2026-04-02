import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Create User ──────────────────────────────────────────────────
  Future<void> createUser({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'gender': '',
      'nationality': '',
      'maritalStatus': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Get User ─────────────────────────────────────────────────────
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) return UserModel.fromMap(doc.data()!);
    return null;
  }

  // ── Update User ──────────────────────────────────────────────────
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // ── Get Categories (dynamic from Firestore) ──────────────────────
  Future<List<Map<String, dynamic>>> getCategories() async {
    final snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ── Get Category Content ─────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getCategoryItems(
      String categoryId) async {
    final snapshot = await _db
        .collection('categories')
        .doc(categoryId)
        .collection('items')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}