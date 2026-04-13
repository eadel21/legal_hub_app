import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
    required String photoUrl,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photo': photoUrl,
      'gender': '',
      'nationality': '',
      'maritalStatus': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) return UserModel.fromMap(doc.data()!);
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getCategoryItems(String categoryId) async {
    final snapshot = await _db
        .collection('categories')
        .doc(categoryId)
        .collection('items')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getLawyers({String? categoryId}) async {
    Query query = _db.collection('lawyers');
    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAppointments(String uid) async {
    final snapshot = await _db
        .collection('appointments')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  Future<void> createAppointment(Map<String, dynamic> data) async {
    await _db.collection('appointments').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

Future<void> submitLawyerApplication(Map<String, dynamic> data) async {
  await _db.collection('lawyer_applications').add({
    ...data,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  }).timeout(
    const Duration(seconds: 15),
    onTimeout: () => throw Exception(
      'Connection timed out. Check your internet or Firestore rules.',
    ),
  );
}

  Future<List<Map<String, dynamic>>> getInsurancePlans() async {
    final snapshot = await _db.collection('insurance_plans').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  Future<String> getOrCreateChat({
    required String currentUid,
    required String otherUid,
    required String otherName,
    required String currentName,
  }) async {
    final existing = await _db
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .get();

    for (final doc in existing.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUid)) return doc.id;
    }

    final newChat = await _db.collection('chats').add({
      'participants': [currentUid, otherUid],
      'otherName': otherName,
      'currentName': currentName,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
    return newChat.id;
  }
}