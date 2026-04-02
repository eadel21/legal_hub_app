class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String nationality;
  final String maritalStatus;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    this.gender = '',
    this.nationality = '',
    this.maritalStatus = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      nationality: map['nationality'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'nationality': nationality,
      'maritalStatus': maritalStatus,
    };
  }
}