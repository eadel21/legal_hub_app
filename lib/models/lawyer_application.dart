import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerApplicationModel {
  final String uid;
  final String fullName;
  final int experience;
  final int graduationYear;
  final String fileUrl;
  final String status;

  LawyerApplicationModel({
    required this.uid,
    required this.fullName,
    required this.experience,
    required this.graduationYear,
    required this.fileUrl,
    required this.status,
  });

  factory LawyerApplicationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LawyerApplicationModel(
      uid: data['uid'] ?? '',
      fullName: data['fullName'] ?? '',
      experience: data['experience'] ?? 0,
      graduationYear: data['graduation year'] ?? 0,
      fileUrl: data['fileUrl'] ?? '',
      status: data['status'] ?? 'under_review',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'experience': experience,
      'graduation year': graduationYear,
      'fileUrl': fileUrl,
      'status': status,
    };
  }
}