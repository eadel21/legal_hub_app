class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String photoUrl;
  final String gender;
  final String nationality;
  final String maritalStatus;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.gender,
    required this.nationality,
    required this.maritalStatus,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      gender: data['gender'] ?? '',
      nationality: data['nationality'] ?? '',
      maritalStatus: data['maritalStatus'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'gender': gender,
      'nationality': nationality,
      'maritalStatus': maritalStatus,
    };
  }
}