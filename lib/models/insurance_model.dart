import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceModel {
  final String id;
  final String userId;
  final String policyNumber;
  final String type;
  final String status;

  InsuranceModel({
    required this.id,
    required this.userId,
    required this.policyNumber,
    required this.type,
    required this.status,
  });

  factory InsuranceModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InsuranceModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      policyNumber: data['policyNumber'] ?? '',
      type: data['type'] ?? '',
      status: data['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'policyNumber': policyNumber,
      'type': type,
      'status': status,
    };
  }
}