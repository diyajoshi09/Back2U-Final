class AuthUser {
  final String id;
  final String universityId;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? profileImageUrl;
  final bool isVerified;

  AuthUser({
    required this.id,
    required this.universityId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profileImageUrl,
    required this.isVerified,
  });

  String get fullName => '$firstName $lastName';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] ?? '',
      universityId: json['university_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profile_image_url'],
      isVerified: json['is_verified'] ?? false,
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
      'is_verified': isVerified,
    };
  }
}

class Admin {
  final String id;
  final String username;
  final String fullName;
  final String email;

  Admin({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
