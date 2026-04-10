import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String lawyerId;
  final DateTime dateTime;
  final String notes;
  final String status;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.lawyerId,
    required this.dateTime,
    required this.notes,
    required this.status,
  });

  factory AppointmentModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      lawyerId: data['lawyerId'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      notes: data['notes'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lawyerId': lawyerId,
      'dateTime': Timestamp.fromDate(dateTime),
      'notes': notes,
      'status': status,
    };
  }
}