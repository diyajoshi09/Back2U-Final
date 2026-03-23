class UserModel {
  final String id;
  final String universityId;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.universityId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      universityId: json['university_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'profile_image_url': profileImageUrl,
    };
  }

  String get fullName => '$firstName $lastName';
}
