class UserModel {
  final String id;
  final String email;
  final String? token;
  final bool isLoggedIn;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.token,
    this.isLoggedIn = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      isLoggedIn: json['isLoggedIn'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
      'isLoggedIn': isLoggedIn ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'token': token,
      'isLoggedIn': isLoggedIn ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      token: map['token'],
      isLoggedIn: map['isLoggedIn'] == 1,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }
}