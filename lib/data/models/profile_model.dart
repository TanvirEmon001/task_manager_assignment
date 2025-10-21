class ProfileModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String password;
  final String createdDate;

  String get fullName {
    return '$firstName $lastName';
  }

  ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.password,
    required this.createdDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> jsonData) {
    return ProfileModel(
      id: jsonData['_id'],
      email: jsonData['email'],
      firstName: jsonData['firstName'],
      lastName: jsonData['lastName'],
      mobile: jsonData['mobile'],
      password: jsonData['password'] ?? '',
      createdDate: 'createdDate',
    );
  }

}
